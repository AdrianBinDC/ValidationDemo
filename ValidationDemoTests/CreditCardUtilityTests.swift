//
//  CreditCardUtilityTests.swift
//  ValidationDemoTests
//
//  Created by Adrian Bolinger on 6/13/20.
//  Copyright © 2020 Adrian Bolinger. All rights reserved.
//

@testable import ValidationDemo
import XCTest

class CreditCardUtilityTests: XCTestCase {
    
    /*
     Here, we define all the scenarios we're going to throw at the
     CreditCardUtility. We want to test as much code as possible in
     CreditCardUtility and write the tests in a manner where if a test
     fails, we know "directionally" where to look for the failure.
     
     Don't stuff 20 pounds of test code in a 5 bag. We want the tests to be
     granular so we can quickly identify specifically what within the class broke.
     */
    
    enum DemoCard: String, CaseIterable {
        case amex = "343047786517463"
        case mastercard = "5127179035326007"
        case visa = "4425218577312280"
        case validPartialAmex = "3712"
        case validPartialMastercard = "5532584"
        case validPartialVisa = "41004004334772"
        case invalid15 = "012345678912345"
        case invalid16 = "0123456789123456"
        case invalidCharacters4 = "abc123"
        case invalidCharacters15 = "abcd12345678912"
        case invalidCharacters16 = "abcd123456789123"
        case invalidCharactersTooLong = "01234567890123456"
    }

    func testAmericanExpress() {
        let sut = CreditCardUtility()
        let cardNumberToEvaluate = DemoCard.amex.rawValue
        let actualCardType = sut.creditCardType(for: cardNumberToEvaluate)
        XCTAssertEqual(actualCardType, CreditCardType.americanExpress)
        XCTAssertTrue(sut.isValid(cardNumber: cardNumberToEvaluate))
        XCTAssertNotNil(sut.image(for: cardNumberToEvaluate))
        
    }
    
    func testMastercard() {
        let sut = CreditCardUtility()
        let cardNumberToEvaluate = DemoCard.mastercard.rawValue
        let actualCardType = sut.creditCardType(for: cardNumberToEvaluate)
        XCTAssertEqual(actualCardType, CreditCardType.mastercard)
        XCTAssertTrue(sut.isValid(cardNumber: cardNumberToEvaluate))
        XCTAssertNotNil(sut.image(for: cardNumberToEvaluate))
    }
    
    func testVisa() {
        let sut = CreditCardUtility()
        let cardNumberToEvaluate = DemoCard.visa.rawValue
        let actualCardType = sut.creditCardType(for: cardNumberToEvaluate)
        XCTAssertEqual(actualCardType, CreditCardType.visa)
        XCTAssertTrue(sut.isValid(cardNumber: cardNumberToEvaluate))
        XCTAssertNotNil(sut.image(for: cardNumberToEvaluate))
    }
    
    func testPartialValidNumbers() {
        let sut = CreditCardUtility()
        
        let validPartialNumbers: [String] = {
            let constrainedCardTypes: [DemoCard] = [
                .validPartialAmex,
                .validPartialMastercard,
                .validPartialVisa
            ]

            return constrainedCardTypes.map { $0.rawValue }
        }()
        
        validPartialNumbers.forEach { partialCardNumber in
            XCTAssertEqual(sut.creditCardType(for: partialCardNumber), CreditCardType.undetermined)
            XCTAssertTrue(sut.isValid(cardNumber: partialCardNumber))
            XCTAssertNil(sut.image(for: partialCardNumber))
        }
    }
    
    func testPartialInvalidNumbers() {
        let sut = CreditCardUtility()
        
        let invalidPartialNumbers: [String] = {
            let constrainedCardTypes: [DemoCard] = [
                .invalid15,
                .invalid16,
                .invalidCharacters4,
                .invalidCharacters15,
                .invalidCharacters16,
                .invalidCharactersTooLong
            ]

            return constrainedCardTypes.map { $0.rawValue }
        }()
        
        invalidPartialNumbers.forEach { partialCardNumber in
            XCTAssertEqual(sut.creditCardType(for: partialCardNumber), CreditCardType.invalid)
            XCTAssertFalse(sut.isValid(cardNumber: partialCardNumber))
            XCTAssertNil(sut.image(for: partialCardNumber))
        }
    }
}
