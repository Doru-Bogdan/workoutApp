//
//  Config.swift
//  QuickTrain-iOS
//

import Foundation

struct Config {
    
    struct Network {
        static let useStaging = false
        
        static var apiAuthBaseUrl: String {
            return "http://localhost:3500"
        }
        static var apiWorkoutBaseUrl: String {
            return "http://localhost:3300"
        }
        static var apiRankingBaseUrl: String {
            return "http://localhost:3600"
        }
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }
}
