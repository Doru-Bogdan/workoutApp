//
//  AuthManager.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 13/11/2020.
//

import Foundation
import Defaults
import RxSwift

extension Defaults.Keys {
    static let token = Key<Token?>("token")
    static let userAccount = Key<UserAccount?>("userAccount")
    static let user = Key<User?>("user")
}

class AuthManager {

    static let shared = AuthManager()

    let tokenChanged = PublishSubject<Token?>()

    var token: Token? {
        get {
            return Defaults[.token]
        }
        set {
            Defaults[.token] = newValue
            tokenChanged.onNext(newValue)
        }
    }
    
    var userAccount: UserAccount? {
        get {
            return Defaults[.userAccount]
        }
        
        set {
            Defaults[.userAccount] = newValue
        }
    }
    
    var user: User? {
        get {
            return Defaults[.user]
        }
        
        set {
            Defaults[.user] = newValue
        }
    }
     
    class func setUserAccount(userAccount: UserAccount) {
        AuthManager.shared.userAccount = userAccount
    }
    
    class func setUser(user: User) {
        AuthManager.shared.user = user
    }

    class func setToken(token: Token) {
        AuthManager.shared.token = token
    }

    class func removeToken() {
        AuthManager.shared.token = nil
        AuthManager.shared.userAccount = nil
        AuthManager.shared.user = nil
    }
}
