//
//  ApiService.swift
//  MVVM-Framework-iOS
//
//  Created by KYUBO A. SHIM on 2023/08/19.
//

import Foundation

import Moya

struct UserLoginInfoModel: Codable {
    let userName: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email, password
        case userName = "username"
    }
}

struct UserPageModel: Codable {
    let page: Int
    let perPage: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
    }
}

enum NetworkApi {
    case fetchListOfUsers(_ page: UserPageModel)    // OK
    case fetchSingleUser(_ user: Int)
    case fetchDelayedResponse(_ user: Int)
    case postLoginSuccess(_ userInfo: UserLoginInfoModel)
    case registerSuccess(_ userInfo: UserLoginInfoModel)
}

extension NetworkApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://reqres.in/api") else {
            print("No Available URL")
            return URL(string: "")!
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchListOfUsers:     // page as param
            return "/users"
        case .fetchSingleUser(let user):
            return "/users/\(user)"
        case .fetchDelayedResponse: // delay as param
            return "/users"
        case .postLoginSuccess:
            return "/login"
        case .registerSuccess:
            return "/register"
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
        case .registerSuccess:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchListOfUsers(let page):
            do {
                let parameter = try page.asParameter()
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } catch let error {
                print(error)
                return .requestPlain
            }
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
        case .registerSuccess(let newUserInfo):
            do {
                let parameter = try newUserInfo.asParameter()
                return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
            } catch let error {
                print(error)
                return .requestPlain
            }
        }
    }
    
    var headers: [String : String]? {
        let header = ["Content-Type": "application/json"]
        return header
    }
}
