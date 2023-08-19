//
//  ApiService.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/19.
//

import Foundation

import Moya

struct userLoginInfoModel: Codable {
    let email: String
    let password: String
}

enum NetworkApi {
    case fetchListOfUsers(_ page: Int)
    case fetchSingleUser(_ user: Int)
    case fetchDelayedResponse(_ user: Int)
    case postLoginSuccess(_ userInfo: userLoginInfoModel)
}

extension NetworkApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://reqres.in") else {
            print("No Available URL")
            return URL(string: "")!
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchListOfUsers:     // page as param
            return "/api/users"
        case .fetchSingleUser(let user):
            return "/api/users/\(user)"
        case .fetchDelayedResponse: // delay as param
            return "/api/users"
        case .postLoginSuccess:
            return "/api/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchListOfUsers:
            return .get
        case .fetchSingleUser:
            return .get
        case .fetchDelayedResponse:
            return .get
        case .postLoginSuccess:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchListOfUsers(let pageIndex):
            let parameter: [String: Any] = ["page": pageIndex]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        case .fetchSingleUser:
            return .requestPlain
        case .fetchDelayedResponse(let delaySeconds):
            let parameter: [String: Any] = ["delay": delaySeconds]
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        case .postLoginSuccess(let userInfo):
            do {
                let parameter = try userInfo.asParameter()
                return .requestParameters(parameters: parameter, encoding: JSONEncoding.default)
            } catch let error {
                print(error)
                return .requestPlain
            }
        }
    }
    
    var headers: [String : String]? {
        var header = ["Content-Type": "application/json"]
        return header
    }
}
