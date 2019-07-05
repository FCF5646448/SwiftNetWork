//
//  DouBanAPI.swift
//  MoyaTest
//
//  Created by 冯才凡 on 2019/7/3.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import Moya

let DouBanProvider = MoyaProvider<DouBan>()

public enum DouBan {
    case channelsApi      // 获取频道列表
    case playlistApi(String) // 获取歌曲
}

extension DouBan: TargetType {
    //服务器地址
    public var baseURL: URL {
        switch self {
        case .channelsApi:
            return URL(string: "https://www.douban.com")!
        case .playlistApi(_):
            return URL(string: "https://douban.fm")!
        }
    }
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .channelsApi:
            return "/j/app/radio/channels"
        case .playlistApi(_):
            return "/j/mine/playlist"
        }
    }
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    //参数
    public var task: Task {
        switch self {
        case .playlistApi(let channel):
            var params = [String: Any]()
            params["channel"] = channel
            params["type"] = "n"
            params["from"] = "mainsite"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    //是否执行Alamofire验证
    public var validate:Bool {
        return false
    }
    
    //单元测试
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    
}

