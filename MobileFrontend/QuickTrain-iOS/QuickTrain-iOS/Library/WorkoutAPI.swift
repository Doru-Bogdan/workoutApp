//
//  WorkoutAPI.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 13/11/2020.
//

import Foundation

import Moya

enum WorkoutAPI {
    case login(email: String, password: String)
    case register(user: GenericUser)
    case getUserAccount
    case getUser(id: String)
    case getAllWorkoutTypes
    case getCategoryVideos(categoryId: Int)
    case getWorkout(workoutId: String)
    case getTopTenUsers
    case updateUser(user: User)
    case uploadNewExercise(workoutVideo: WorkoutVideo)
}

extension WorkoutAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .login, .register, .getUserAccount, .getUser, .updateUser:
            return URL(string: Config.Network.apiAuthBaseUrl)!
        case .getAllWorkoutTypes, .getCategoryVideos, .getWorkout, .uploadNewExercise:
            return URL(string: Config.Network.apiWorkoutBaseUrl)!
        case .getTopTenUsers:
            return URL(string: Config.Network.apiRankingBaseUrl)!
        }
//        return URL(string: Config.Network.apiBaseUrl)!
    }
    
    public var path: String {
        switch self {
        case .login: return "auth/login"
        case .register: return "auth/register"
        case .getUserAccount: return "users/account"
        case .getUser(let id): return "users/\(id)"
        case .getAllWorkoutTypes: return "workout-types"
        case .getCategoryVideos(let categoryId): return "workout/type/\(categoryId)"
        case .getWorkout(let workoutId): return "workout/\(workoutId)"
        case .getTopTenUsers: return "ranking/ranking-for-a-date"
        case .updateUser(let user): return "users/\(user.id ?? "")"
        case .uploadNewExercise: return "workout"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login, .register, .uploadNewExercise, .getTopTenUsers:
            return .post
        case .updateUser:
            return .put
        default:
            return .get
        }
    }
    
    public var headers: [String: String]? {
        if let token = AuthManager.shared.token {
            switch token.type() {
            case .bearer(let token):
                return ["Authorization": "Bearer \(token)"]
            case .unauthorized: break
            }
        }
        return nil
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(parameters: ["email": email, "password": password],
                                      encoding: JSONEncoding.default)
        case let .register(user):
            if let email = user.email,
               let username = user.username,
               let password = user.password,
               let firstName = user.firstName,
               let lastName = user.lastName {
                return .requestParameters(parameters: ["email" : email,
                                                       "login" : username,
                                                       "first_name" : firstName,
                                                       "last_name" : lastName,
                                                       "password" : password], encoding: JSONEncoding.default)
            }
            return .requestPlain
            
        case .getTopTenUsers:
            return .requestParameters(parameters: ["date" : "\(Date())"], encoding: JSONEncoding.default)
        case let .updateUser(user):
            if let currentPoints = user.currentPoints,
               let level = user.level {
                return .requestParameters(parameters: ["certificateUrl": user.certificateURL as Any,
                                                       "currentPoints": currentPoints,
                                                       "level": level], encoding: JSONEncoding.default)
            }
            return .requestPlain
        case let .uploadNewExercise(workoutVideo):
            if let workoutTitle = workoutVideo.title,
               let workoutVideoUrl = workoutVideo.videoURL,
               let workoutThumbnailUrl = workoutVideo.thumbnailURL,
               let workoutIdType = workoutVideo.workoutTypeID,
               let workoutRequiredXp = workoutVideo.xpRequired,
               let workoutValueXp = workoutVideo.xpValue,
               let workoutDescription = workoutVideo.description {
                return .requestParameters(parameters: ["workoutTitle" : workoutTitle,
                                                       "workoutVideoUrl" : workoutVideoUrl,
                                                       "workoutThumbnailUrl" : workoutThumbnailUrl,
                                                       "workoutIdType" : workoutIdType,
                                                       "workoutRequiredXp" : workoutRequiredXp,
                                                       "workoutValueXp": workoutValueXp,
                                                       "workoutDescription": workoutDescription], encoding: JSONEncoding.default)
            }
            return .requestPlain
        default:
            return .requestPlain
        }
    }
    
    public func url(route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
