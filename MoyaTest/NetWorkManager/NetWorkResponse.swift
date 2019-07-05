//
//  NetWorkResponse.swift
//  MoyaTest
//
//  Created by 冯才凡 on 2019/7/4.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import HandyJSON

//对response进行处理
class BaseResponse {
    let json: [String : Any]
    
    //页数
    var page:Int {
        guard let temp = json["page"] as? Int else {
            return 0
        }
        return temp
    }
    
    //每一页数据
    var pagesize:Int {
        guard let temp = json["pagesize"] as? Int else {
            return 0
        }
        return temp
    }
    
    //返回的code 200 才是正解
    var code:Int {
        guard let temp = json["code"] as? Int else {
            return -1
        }
        return temp
    }
    //如果数据错误，会返回msg或tips 优先级是 tip > msg
    var msgTip:String {
        if let tip = json["tip"] as? String {
            return tip
        }else if let msg = json["msg"] as? String {
            return msg
        }
        return ""
    }
    
    // 真正有用的model数据 它可能是数组也可能是字典
    var jsonData:Any? {
        guard let temp = json["res"] else { //res
            return nil
        }
        return temp
    }
    
    init?(data: Any) {
        guard let temp = data as? [String : Any] else {
            return nil
        }
        self.json = temp
    }
    
    func json2Data(_ objc:Any) -> Data? {
        return try? JSONSerialization.data(withJSONObject: objc, options: [])
    }
    
    func json2String(_ objc:Any) -> String? {
        if let tempD = json2Data(objc) {
            return String(data: tempD, encoding: String.Encoding.utf8)
        }
        return nil
    }
}

/* 默认的model结果是{code:xx; res:{} (或者 res:[]); msg:xx; tip:xx}, 基本所有可用的model都是建立在res之内的。所以 resData与resDatas就分别对应res作为{}和[];
 * 如果有不符合上述结构，则取resObj的数据，不过它肯定是个{}
 */
class ModelResponse<T>: BaseResponse where T: HandyJSON {
    //字典
    var resData:T? {
        guard code == 200,
            let tempJSONData = jsonData,
            let temp = json2String(tempJSONData) else {
                return nil
        }
        
        return T.deserialize(from: temp)
    }
    //数组
    var resDatas:[T]? {
        guard code == 200,
            let tempJSONData = jsonData,
            let temp = json2String(tempJSONData) else {
            return nil
        }
        return [T].deserialize(from: temp) as? [T]
    }
    
    //可能是一个502的网页
    var resObj:T? {
        guard let temp = json2String(self.json) else {
            return nil
        }
        return T.deserialize(from: temp)
    }
    
    
}
