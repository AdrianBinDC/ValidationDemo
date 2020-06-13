//
//  CreditCardUtility.swift
//  ValidationDemo
//
//  Created by Adrian Bolinger on 6/13/20.
//  Copyright © 2020 Adrian Bolinger. All rights reserved.
//

import UIKit

enum CreditCardType: String, CaseIterable {
    case americanExpress = "card-amex"
    case mastercard = "card-mastercard"
    case visa = "card-visa"
    case undetermined
    case invalid
    
    var regularExpression: String? {
        switch self {
        case .americanExpress:
            return "3[47][0-9]{13}"
        case .mastercard:
            return "^(5[1-5][0-9]{14}|2(22[1-9][0-9]{12}|2[3-9][0-9]{13}|[3-6][0-9]{14}|7[0-1][0-9]{13}|720[0-9]{12}))$"
        case .visa:
            return "^4[0-9]{12}(?:[0-9]{3})?$"
        case .invalid, .undetermined:
            return nil
        }
    }
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
    
    static var knownTypes: [CreditCardType] {
        return [.americanExpress, .mastercard, visa]
    }
}

/*
 When validating credit card numbers, regular expressions should be used. For the purposes of this exercise, we'll use regular expressions I found here:
 
 https://stackoverflow.com/a/23231321/4475605
*/
class CreditCardUtility {
    func creditCardType(for cardNumber: String) -> CreditCardType {
        var regularExpression: NSRegularExpression?
        let range = NSRange(location: 0, length: cardNumber.utf16.count)
        // we start out not knowing what kind of card we've got
        var cardType: CreditCardType = .undetermined
        
        switch cardNumber.count {
        case 0..<15:
            // Anything from 0 to 14 characters can be any type of credit card
            // Partial validation with regular expressions for 3 different card types is pretty messy
            // So in the interest of getting this out the door, we just check for invalid characters
            // and once there are 15-16 characters, we'll figure out what kind it is
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: cardNumber)) {
                cardType = .invalid
            }
        case 15...16:
            // Anything from 15 to 16 can be amex, mastercard, visa
            let cardTypes = CreditCardType.knownTypes
            
            cardTypes.forEach { _cardType in
                // we're guaranteed a value for regular expression because we've constrained to known types
                regularExpression = try? NSRegularExpression(pattern: _cardType.regularExpression!, options: [])
                if regularExpression?.firstMatch(in: cardNumber, options: [], range: range) != nil {
                    cardType = _cardType
                }
            }
            
            // if after going through all the card types and we still don't know what it is, it's an invalid card type
            if cardType == .undetermined {
                cardType = .invalid
            }
        default:
            cardType = .invalid
        }
        
        return cardType
    }
    
    func isValid(cardNumber: String) -> Bool {
        let cardType = creditCardType(for: cardNumber)
        
        switch cardType {
        case .americanExpress, .mastercard, .visa, .undetermined:
            return true
        case .invalid:
            return false
        }
    }
    
    func image(for cardNumber: String) -> UIImage? {
        creditCardType(for: cardNumber).image
    }
}
