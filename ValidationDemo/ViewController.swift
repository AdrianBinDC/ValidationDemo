//
//  ViewController.swift
//  ValidationDemo
//
//  Created by Adrian Bolinger on 6/12/20.
//  Copyright © 2020 Adrian Bolinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pickerView: UIPickerView!
    
    struct PickerElement {
        let fieldName: String
        let cardNumberString: String
    }
    
    /* This is more appropriate in a view model, but for the sake of simplicity doing MVC */
    /* This is a lazy declaration, so it fires when it's needed, not before. */
    private lazy var pickerElements: [PickerElement] = {
        /*
         Enable code folding in Xcode. While this declaration appears verbose, you can collapse it.
         Easy to read = easy to debug.
         */
        let fieldNames = [
            "American Express",
            "Mastercard",
            "Visa",
            "Valid Partial AmEx",
            "Valid Partial MC",
            "Valid Partial Visa",
            "Invalid 15 Chars",
            "Invalid 16 Chars",
            "Invalid 4 Chars",
            "Invalid Chars 15",
            "Invalid Chars 16",
            "Invalid Too Long (17 Chars)"
        ]
        
        var cardNumbers = [
            "343047786517463",
            "5127179035326007",
            "4425218577312280",
            "3712",
            "5532584",
            "41004004334772",
            "012345678912345",
            "0123456789123456",
            "abc123",
            "abcd12345678912",
            "abcd123456789123",
            "01234567890123456"
        ]
        
        var elements: [PickerElement] = []
        
        zip(fieldNames, cardNumbers).forEach { name, number in
            let element = PickerElement(fieldName: name,
                                        cardNumberString: number)
            elements.append(element)
        }
        
        return elements
    }()
    
    // Nobody needs to know about this outside the class, so we mark it private
    private let cardUtility = CreditCardUtility()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupPickerView()
    }
    
    // MARK: - Configuration Methods
    func setupTextFields() {
        textField.delegate = self // not implementing any of them, but putting this here in case you decide to
        textField.addTarget(self,
                            action: #selector(textFieldDidChange(_:)),
                            for: .editingChanged)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .numberPad
    }
    
    func setupPickerView() {
        pickerView.delegate = self
    }
    
    // MARK: - Helper Methods
    func updateTextField() {
        guard let cardNumberString = textField.text else {
            return
        }
        
        let isValidCardNumber = cardUtility.isValid(cardNumber: cardNumberString)
                
        if isValidCardNumber {
            textField.textColor = .green
        } else {
            textField.textColor = .red
        }
        
        imageView.image = cardUtility.image(for: cardNumberString)
        imageView.setNeedsDisplay()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateTextField()
    }
}

// Mark your code so it's easier to navigate and keep everything nice & neat

// MARK: - UITextFieldDelegate Methods
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // This restricts the textField to just numbers
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

// MARK: - UIPickerViewDelegate Methods
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElements[row].fieldName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickerElements[row].cardNumberString
        updateTextField()
    }
}

// MARK: - UIPickerViewDataSource Methods
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElements.count
    }
}



