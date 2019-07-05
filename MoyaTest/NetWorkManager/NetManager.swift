//
//  NetManager.swift
//  Mojave
//
//  Created by 冯才凡 on 2019/7/5.
//  Copyright © 2019 卓明. All rights reserved.
//

import Foundation
import HandyJSON
import Moya

// 为了
class NetManager<T> where T: HandyJSON {
    
    var target:ApiRequestObj?
    //请求参数
    var param:[String:Any]?
    
    //用于取消
    var cancelable:Cancellable?
    
    //
    var progress:((Double)->Void)?=nil
    var success:((ModelResponse<T>?) -> Void)?=nil
    var error:((String)->Void)?=nil
    var failure:((MoyaError)->Void)?=nil

    /* param：可不传，只在分页情况下传参
     * success：服务器连接成功，且数据正确返回（同时会自动将数据转换成 JSON 对象，方便使用）
     * error：服务器连接成功，但数据返回错误（同时会返回错误信息）
     * failure ：服务器连接不上，网络异常等
     * return: 返回一个cancelable 可用于取消
     */
    func request<R:ApiRequestProtocol>(_ target:R,
                               _ param:[String:Any]?=nil,
                               progress progressBlock:((Double)->Void)?=nil,
                               success successCallback:((ModelResponse<T>?) -> Void)?=nil,
                               error errorCallback:((String)->Void)?=nil,
                               failure failureCallback:((MoyaError)->Void)?=nil) {
        let obj:ApiRequestObj = ApiRequestObj()
        obj.api = (target as! ApiRequest)
        obj.param = param ?? [:]
        self.target = obj
        
        self.progress = progressBlock
        self.success  = successCallback
        self.error    = errorCallback
        self.failure  = failureCallback
        
        self.cancelable = NetWorkManager<T>().request(obj, progress: self.progress, success: self.success, error: self.error, failure: self.failure)
    }
    
    
    /* 取消正在进行的请求
     */
    func cancel() {
        self.cancelable?.cancel()
    }
    
    /* 重新请求当前接口
     */
    func reload<R:TargetType>(_ target:R) {
        guard let target = self.target else {
            return
        }
        var param:[String:Any] = target.param
        if (param["page"] as? Int) != nil {
            param["page"] =  0
        }
        
        self.cancelable = NetWorkManager<T>().request(target, progress: self.progress, success: self.success, error: self.error, failure: self.failure)
    }
    
    /* 请求下一页
     */
    func loadNextPage() { //<R:TargetType>(_ target:R)
        guard let target = self.target else {
            return
        }
        var param:[String:Any] = target.param
        if let page = param["page"] as? Int {
            param["page"] =  page + 1
        }
        
        self.cancelable = NetWorkManager<T>().request(target, progress: self.progress, success: self.success, error: self.error, failure: self.failure)
    }
    
    
}
