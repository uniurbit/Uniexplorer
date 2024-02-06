//
//  FileUtility.swift
//  ITWA
//
//  Created by Manuela on 16/04/2020.
//  Copyright © 2020 VJ Technology. All rights reserved.
//

import Foundation
import AVFoundation
import PDFKit
import Kingfisher

class FileUtility {
    
    internal static func downloadImageFromUrl(imgUrl: String?, imgView: UIImageView, placeholderImg: UIImage = UIImage()){
        guard let imgUrl else {return}
        let url = URL(string: imgUrl)
        let processor = DownsamplingImageProcessor(size: imgView.frame.size)
        
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(
            with: url,
            placeholder: placeholderImg,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ])
        

    }
    
    internal static func downloadImageBtnFromUrl(imgUrl: String?, btn: UIButton, placeholderImg: UIImage = UIImage()){
        guard let imgUrl else {return}
        let url = URL(string: imgUrl)
        let processor = RoundCornerImageProcessor(radius: .widthFraction(0.5))
        
        btn.kf.setImage(with: url, for: .normal, placeholder: nil, options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.2)),
            .cacheOriginalImage,
            .cacheSerializer(FormatIndicatedCacheSerializer.png) // Per non perdere la trasparenza se l'immagine è png
        ], progressBlock: nil, completionHandler: nil)
            
        

    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        Logger.log.info("document PATH \(documentsDirectory.absoluteString)")

        return documentsDirectory
    }
    
    internal static func decodeBase64ToImage(base64: String?) -> UIImage? {
        guard base64 != nil else {
            return nil
        }
        if
            let dataDecoded : Data = Data(base64Encoded: base64!, options: Data.Base64DecodingOptions(rawValue: 0)),
            let decodedimage : UIImage = UIImage(data: dataDecoded as Data)
        {
            return decodedimage
        }
        return nil
    }
    
    internal static func imageFromVideo(url: URL, at time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset(url: url)
        let assetIG = AVAssetImageGenerator(asset: asset)
        assetIG.appliesPreferredTrackTransform = true
        assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        
        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImageRef: CGImage
        do {
            thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        return UIImage(cgImage: thumbnailImageRef)
    }
    
    internal static func imageFromPdf(url: URL, at page: Int, previewWidth: CGFloat) -> UIImage? {
        guard let data = try? Data(contentsOf: url),
        let page = PDFDocument(data: data)?.page(at: 0) else {
          return nil
        }
        let pageSize = page.bounds(for: .mediaBox)
        let pdfScale = previewWidth / pageSize.width
        let scale = UIScreen.main.scale * pdfScale
        let screenSize = CGSize(width: pageSize.width * scale,
                                height: pageSize.height * scale)
        
        
        return page.thumbnail(of: screenSize, for: .mediaBox)
    }
    
    internal static func takeScreenshot(view: UIView) -> UIImageView {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        view.layer.backgroundColor = UIColor.white.cgColor
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
    
    internal static func getFileSize(filePath:String)->Int?{
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: filePath)
            return attr[FileAttributeKey.size] as? Int
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    internal static func compressUnder(fileUrl: URL, image: UIImage?, maxBytes: CGFloat) -> URL {
        guard let f = FileUtility.getFileSize(filePath: fileUrl.path), f > 5242880 else {
            return fileUrl
        }
        
        var imageFromUrl = image
        if imageFromUrl == nil {
            imageFromUrl = UIImage(data: try! Data(contentsOf: fileUrl))!
        }
        
        let compressedUrl = imageFromUrl!.compressTo(3)
        if compressedUrl != nil {
            return compressedUrl!
        }
        else {
            return fileUrl
        }
    }
    
    
    static func saveFile(fileData:Data, fileName: String) -> URL? {
        var docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        docURL = docURL?.appendingPathComponent(fileName)
        if docURL != nil {
            do{
                try fileData.write(to: docURL!)
                //Ho salvato il file
                return docURL!
            }catch{
                //Non sono riuscito a salvare il file
                return nil
            }
        }else{
            //Non sono riuscito a costruire il URL
            return nil
        }
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func sharePdf(pdf:Data, pdfName: String, vc: UIViewController) {
        DispatchQueue.main.async {
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = pdfName
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdf.write(to: actualPath, options: .atomic)
                do{
                    let contents  = try FileManager.default.contentsOfDirectory(at: resourceDocPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for i in 0..<contents.count {
                        if contents[i].lastPathComponent == actualPath.lastPathComponent {
                            let docController = UIDocumentInteractionController(url: contents[i])
                            docController.delegate = vc as? UIDocumentInteractionControllerDelegate
                            //See preview of PDF
                            docController.presentPreview(animated: true)
                            //See share menu
//                            docController.presentOptionsMenu(from: vc.view.frame, in: vc.view, animated:true)
                        }
                    }
                }
                catch (let err){
                    print("error: \(err)")
                }
            }catch (let writeError) {
                print("Error creating a file \(actualPath) : \(writeError)")
            }
        }
    }
    
    
    static func savePdf(pdf:Data, pdfName: String, vc: UIViewController) {
        DispatchQueue.main.async {
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = pdfName
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdf.write(to: actualPath, options: .atomic)
                do{
                    let contents  = try FileManager.default.contentsOfDirectory(at: resourceDocPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for i in 0..<contents.count {
                        if contents[i].lastPathComponent == actualPath.lastPathComponent {
                            let activityViewController = UIActivityViewController(activityItems: [contents[i]], applicationActivities: nil)
                            vc.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
                catch (let err){
                    print("error: \(err)")
                }
            }catch (let writeError) {
                print("Error creating a file \(actualPath) : \(writeError)")
            }
        }
    }
}
