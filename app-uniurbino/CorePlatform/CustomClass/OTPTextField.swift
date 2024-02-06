//
//  OTPTextField.swift
//  Vivibanca
//
//  Created by Lorenzo on 06/04/22.
//

import Foundation
import UIKit


class OneTimeCodeTextField: GenericTextfield {
    // MARK: UI Components
    private(set) var digitLabels = [UILabel]()
    
    // MARK: Delegates
    private lazy var oneTimeCodeDelegate = OneTimeCodeTextFieldDelegate(oneTimeCodeTextField: self)
    
    // MARK: Properties
    private var isConfigured = false
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    // MARK: Completions
    public var didReceiveCode: ((String) -> Void)?
    public var otpDidChange: ((String) -> Void)?

    // MARK: Customisations
    /// Needs to be called after `configure()`.
    /// Default value: `.secondarySystemBackground`
    public var codeBackgroundColor: UIColor = .white
    
    /// Needs to be called after `configure()`.
    /// Default value: `.label`
    public var codeTextColor: UIColor = .label {
        didSet {
            digitLabels.forEach({ $0.textColor = codeTextColor })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: `.systemFont(ofSize: 24)`
    public var codeFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            digitLabels.forEach({ $0.font = codeFont })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: 0.8
    public var codeMinimumScaleFactor: CGFloat = 0.8 {
        didSet {
            digitLabels.forEach({ $0.minimumScaleFactor = codeMinimumScaleFactor })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: 8
    public var codeCornerRadius: CGFloat = 8 {
        didSet {
            digitLabels.forEach({ $0.layer.cornerRadius = codeCornerRadius })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: `.continuous`
    public var codeCornerCurve: CALayerCornerCurve = .continuous {
        didSet {
            digitLabels.forEach({ $0.layer.cornerCurve = codeCornerCurve })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: 0
    public var codeBorderWidth: CGFloat = 0 {
        didSet {
            digitLabels.forEach({ $0.addLine(position: .bottom, color: codeBorderColor ?? .label, width: 1)})
        }
    }
    

    
    /// Needs to be called after `configure()`.
    /// Default value: `.none`
    public var codeBorderColor: UIColor? = .none {
        didSet {
            digitLabels.forEach({ $0.layer.borderColor = codeBorderColor?.cgColor })
        }
    }
        
    // MARK: Configuration
    public func configure(withSlotCount slotCount: Int = 6, andSpacing spacing: CGFloat = 8, andOpenKeyboard open: Bool = true ) {
        guard isConfigured == false else { return }
        isConfigured = true
        configureTextField(openKeyboard: open)
        if slotCount == 6{
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillProportionally
            stackView.spacing = 18
            
            let slotsStackView = generateSlotsStackView(with: 3, spacing: spacing)
            let slotsStackView2 = generateSlotsStackView(with: 3, spacing: spacing)
            stackView.addArrangedSubview(slotsStackView)
            stackView.addArrangedSubview(slotsStackView2)

            addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
                stackView.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: trailingAnchor, multiplier: -10),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10)
            ])
        }else{
            let slotsStackView = generateSlotsStackView(with: slotCount, spacing: spacing)
            
            addSubview(slotsStackView)
            
            NSLayoutConstraint.activate([
                slotsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                slotsStackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
                slotsStackView.trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: trailingAnchor, multiplier: -10),
                slotsStackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10)
            ])
        }
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    private func configureTextField(openKeyboard: Bool) {
        tintColor = .clear
        textColor = .clear
        layer.borderWidth = 0
        borderStyle = .none
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        backgroundColor = codeBackgroundColor
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        addTarget(self, action: #selector(textDidBegin), for: .editingDidBegin)

        delegate = oneTimeCodeDelegate
        if openKeyboard{
            becomeFirstResponder()
        }
    }
    
    private func generateSlotsStackView(with count: Int, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        
        for _ in 0..<count{
            let slotLabel = generateSlotLabel()
            stackView.addArrangedSubview(slotLabel)
            digitLabels.append(slotLabel)
        }
        
        return stackView
    }
    
    private func generateSlotLabel() -> UILabel {
        let label = UppercasedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = codeFont
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.minimumScaleFactor = 1
        label.layer.masksToBounds = true
        label.layer.cornerRadius = codeCornerRadius
        label.layer.cornerCurve = codeCornerCurve
        label.text = "  "
        label.layer.addBorder(edge:.bottom, color: codeBorderColor ?? .blue, thickness: 1)
        
        return label
    }
    
    @objc private func textDidChange() {
        guard let code = text, code.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < code.count {
                let index = code.index(code.startIndex, offsetBy: i)
                currentLabel.text = String(code[index])
            } else {
                currentLabel.text? = "  "
            }
        }
        otpDidChange?(code)

        
        if code.count == digitLabels.count{
            didReceiveCode?(code)
        }
    }
    
    @objc private func textDidBegin() {
        print("entro")
    }
    
    public func clear() {
        guard isConfigured == true else { return }
        digitLabels.forEach({ $0.text = "  " })
        text = ""
    }
    
    func writeCode(code: String, slotCount: Int){
        if code.count != slotCount {return}
        self.text = code
        for i in 0..<digitLabels.count{
            
            if i < code.count {
                let index = code.index(code.startIndex, offsetBy: i)
                digitLabels[i].text = String(code[index])
            } else {
                digitLabels[i].text = "  "
            }
        }
        otpDidChange?(code)

        
        if code.count == digitLabels.count{
            didReceiveCode?(code)
        }
    }
}


class OneTimeCodeTextFieldDelegate: NSObject, UITextFieldDelegate {
    let oneTimeCodeTextField: OneTimeCodeTextField
    
    init(oneTimeCodeTextField: OneTimeCodeTextField) {
        self.oneTimeCodeTextField = oneTimeCodeTextField
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if CharacterSet.letters.isSuperset(of: CharacterSet(charactersIn: string)) || CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)){
            guard let characterCount = textField.text?.count else { return false }
            return characterCount < oneTimeCodeTextField.digitLabels.count || string == ""
        }else {
            return false
        }
        
    }
}

extension OneTimeCodeTextField {
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
    public override func caretRect(for position: UITextPosition) -> CGRect {
        .zero
    }
    
    public override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
}
