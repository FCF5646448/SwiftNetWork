//
//  Httpbin.swift
//  MoyaTest
//
//  Created by 冯才凡 on 2019/7/3.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import Moya

enum HttpbinApi {
    case ip
    case anything(String)
}

extension HttpbinApi: TargetType {
    var baseURL: URL {
        return URL(string: "http://httpbin.org")!
    }
    
    var path: String {
        switch self {
        case .ip:
            return "/ip"
        case .anything(_):
            return "/anything"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        switch self {
        case .anything(let param1):
            var params: [String: Any] = [:]
            params["param1"] = param1
            params["param2"] = "2017"
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var validate: Bool {
        return false
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String: String]? {
        return nil
    }
}

