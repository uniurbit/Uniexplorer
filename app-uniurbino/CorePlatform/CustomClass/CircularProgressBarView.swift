//
//  CircularProgressBarView.swift
//  Vivibanca
//
//  Created by Lorenzo on 25/05/22.
//

import Foundation

import UIKit

class CircularProgressBarView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 104, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.gray.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.red.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    
    
    func progressAnimation(duration: TimeInterval) {
        layer.addSublayer(progressLayer)

        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = true
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    func removeAnimation(){
        progressLayer.removeFromSuperlayer()
        progressLayer.removeAllAnimations()
        
    }
}
