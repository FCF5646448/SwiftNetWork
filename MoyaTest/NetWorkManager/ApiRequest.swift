//
//  ApiRequest.swift
//  MoyaTest
//
//  Created by 冯才凡 on 2019/7/4.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON


//enum Api{
//    case login
//    case channelsApi
//    case playlistApi
//}


protocol ApiRequestProtocol {}

enum ApiRequest : ApiRequestProtocol {
    case login //登陆
    case channelsApi     // 获取频道列表
    case playlistApi // 获取歌曲
}

class ApiRequestObj : TargetType {
    
    var api:ApiRequest!
    
    var baseURL: URL {
        switch api! {
        case .login:
            return URL(string: "https://api.btclass.net")!
        case .channelsApi:
            return URL(string: "https://www.douban.com")!
        case .playlistApi:
            return URL(string: "https://douban.fm")!
        }
    }
    
    var path: String {
        switch api! {
        case .login:
            return "/v1/user/mobile/login"
        case .playlistApi:
            return "/j/mine/playlist"
        case .channelsApi:
            return "/j/app/radio/channels"
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: self.param , encoding:  URLEncoding.default)
    }
    
    var param:[String:Any] = [:]
    
    var method: Moya.Method {
        switch api! {
        case .login:
            return .post
        default:
            return .get
        }
    }
    
    //    这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
}
