//
//  Validation.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 18/11/2020.
//

import Foundation

import Foundation

enum ValidationError: Error {
    case nilValue
    case custom(String)
}

enum ValidatorType {
    case email
    case password
}

enum VailidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password: return PasswordValidator()
        }
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String?) throws -> String
}

struct EmailValidator: ValidatorConvertible {
    
    private let validationRegex = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$"

    func validated(_ value: String?) throws -> String {
        // Throw if we got a nil value
        guard let stringToBeValidated = value else {
            throw ValidationError.nilValue
        }

        // Validate with regex
        let regex = try NSRegularExpression(pattern: validationRegex, options: .caseInsensitive)
        let checkRange = NSRange(location: 0, length: stringToBeValidated.count)
        if regex.firstMatch(in: stringToBeValidated, options: [], range: checkRange) == nil {
            throw ValidationError.custom("Email invalid")
        }

        // Everything went smooth, return the value
        return stringToBeValidated
    }

}

struct PasswordValidator: ValidatorConvertible {
    
    private let validationRegex = #"((?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[ !#$%&" + "\"" + @"'()*+,-.\:;<=>?@\[\]^_`{|}~]).{8,})"#
    
    func validated(_ value: String?) throws -> String {
        // Throw if we get a nil value
        guard let stringToBeValidated = value else {
            throw ValidationError.nilValue
        }
        
        // Throw if regex validation fails
        let regex = try NSRegularExpression(pattern: validationRegex, options: [])
        let checkRange = NSRange(location: 0, length: stringToBeValidated.utf16.count)
        if regex.firstMatch(in: stringToBeValidated, options: [], range: checkRange) == nil {
            throw ValidationError.custom("Insecure password")
        }


        // Everything went smooth, return the value
        return stringToBeValidated
    }

}
