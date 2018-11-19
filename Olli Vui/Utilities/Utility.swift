//
//  Utility.swift
//  Olli Vui
//
//  Created by Man Huynh on 5/9/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
import Firebase

class Utility : NSObject {
    func validationPhoneNumber(phoneNumber : String) -> String {
        let firstCharacter = phoneNumber.first
        if(firstCharacter == "0") {
            let index = phoneNumber.index(after: phoneNumber.startIndex)
            let NewphoneNumber = phoneNumber.substring(from: index)
            return NewphoneNumber
        }
        return phoneNumber
    }
    func convertPhoneNumberToFullFormat(phoneNumber : String) -> String {
        let newPhoneFormat = self.validationPhoneNumber(phoneNumber: phoneNumber)
        return ("+84" + newPhoneFormat)
    }
    func convertPhoneNumberToShortForm(phoneNumber : String) -> String {
        let firstCharacter = phoneNumber.first
        if(firstCharacter == "+") {
            let index = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)
            return ("0" + String(phoneNumber[index...]))
        }
        return phoneNumber
    }
}

extension String {
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
}
