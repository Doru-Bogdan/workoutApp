//
//  NetworkManager.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 13/11/2020.
//

import Foundation
import Moya

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var provider = MoyaProvider<WorkoutAPI>()
    
    init() {
        self.provider = MoyaProvider<WorkoutAPI>(
            plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
        )
    }
}
