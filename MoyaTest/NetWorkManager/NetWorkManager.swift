//
//  NetWorkManager.swift
//  MoyaTest
//
//  Created by 冯才凡 on 2019/7/3.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON
import HandyJSON

var requestTimeOut:Double = 30 //超时时长
class NetWorkManager<T> where T: HandyJSON {
    
    /* 创建provider
     * 设置基础配置
     */
    func createProvider<R:TargetType>(_ target:R,_ param:[String:Any]?=nil)->MoyaProvider<R> {
        let myEndpointClosure = { (target:R) -> Endpoint in
            
            let url = target.baseURL.absoluteString + target.path
            var task = target.task
            
            //TODO: 在这里添加基础参数
            if let p = param {
                // 重新生成 task
                task = .requestParameters(parameters: p, encoding: URLEncoding.default)
            }
            
            
            let endpoint = Endpoint(url: url,
                                    sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                    method: target.method,
                                    task: task,
                                    httpHeaderFields: target.headers)
            requestTimeOut = 30
            //可以这里设置请求时长
            return endpoint
        }
        
        let requestClouse = { (endpoint:Endpoint, done: MoyaProvider.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.timeoutInterval = requestTimeOut
                //TODO: 打印请求参数
                if request.httpBody != nil {
                    print("\(request.url!)"+"\n"+"\(request.httpMethod ?? "")"+"发送参数"+"\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
                }else{
                    print("\(request.url!)"+"\(String(describing: request.httpMethod))")
                }
                done(.success(request))
            } catch {
                done(.failure(MoyaError.underlying(error, nil)))
            }
        }
        
        
        let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
            print("networkPlugin \(changeType)")
            //targetType 是当前请求的基本信息
            switch(changeType){
            case .began:
                //TODO:  添加loading
                print("开始请求网络")
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
            case .ended:
                //TODO: 结束loading
                print("结束")
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        
        let provider = MoyaProvider<R>(endpointClosure: myEndpointClosure, requestClosure: requestClouse, plugins: [networkPlugin, NetworkLoggerPlugin(verbose: false)], trackInflights: false)
        return provider
    }
    
    // 为了需要传page的参数
//    func request<R:TargetType>(_ target:R,
//                               _ param:[String:Any]?=nil,
//                               progress progressBlock:((Double)->Void)?=nil,
//                               success successCallback:((ModelResponse<T>?) -> Void)?=nil,
//                               error errorCallback:((String)->Void)?=nil,
//                               failure failureCallback:((MoyaError)->Void)?=nil)->Cancellable{
//
//        return self.request(target, provider: provider, progress: progressBlock, success: successCallback, error: errorCallback, failure: failureCallback)
//    }
    
    /* success：服务器连接成功，且数据正确返回（同时会自动将数据转换成 JSON 对象，方便使用）
     * error：服务器连接成功，但数据返回错误（同时会返回错误信息）
     * failure ：服务器连接不上，网络异常等
     * return: 返回一个cancelable 可用于取消
     */
    func request<R:TargetType>(_ target:R,
                               progress progressBlock:((Double)->Void)?=nil,
                               success successCallback:((ModelResponse<T>?) -> Void)?=nil,
                               error errorCallback:((String)->Void)?=nil,
                               failure failureCallback:((MoyaError)->Void)?=nil)->Cancellable{
        let provider = createProvider(target)
        let cancellable = provider.request(target , callbackQueue: DispatchQueue.global(), progress: { (p) in
            DispatchQueue.main.async {
                progressBlock?(p.progress)
            }
        }) {result in
            DispatchQueue.main.async {
                switch result {
                case let .success(response):
                    do{
                        //数据返回成功
                        
                        print(String(data: response.data, encoding: String.Encoding.utf8)!)
                        
                        if let res = try ModelResponse<T>(data: response.mapJSON()) {
                            successCallback?(res)
                        }else{
                            errorCallback?("JSON转model失败")
                        }
                    }catch let error {
                        //数据格式有问题 比如
                        errorCallback?(String(data: (error as! MoyaError).response!.data, encoding: String.Encoding.utf8)!)
                    }
                case let .failure(error):
                    // 未链接到服务器
                    failureCallback?(error)
                }
            }
        }
        
        return cancellable
    }
    
}

