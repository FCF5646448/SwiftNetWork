//
//  Response+Ex.swift
//  MoyaTest
//
//  Created by xinyue on 2019/7/4.
//  Copyright © 2019 冯才凡. All rights reserved.
//

import UIKit
import HandyJSON
import Moya

extension Response {
    func model<T: HandyJSON>(_ type: T.Type) throws -> T {
        print("✈ -------------------------------------------- ✈")
        print("[URL]\t:", self.request?.urlRequest?.url ?? "")
        if let paramData = request?.urlRequest?.httpBody {
            do{
                let param = try JSONSerialization.jsonObject(with: paramData, options: JSONSerialization.ReadingOptions.allowFragments)// as? [String: Any]
                print("[PARAM]\t:",param)
            }catch let e {
                print("[PARAM]\t:", String(data: paramData, encoding: String.Encoding.utf8) ?? "[ERROR]\t:\(e.localizedDescription)")
            }
        }
        
        if let header = request?.allHTTPHeaderFields {
            print("[HEADER]\t:",header)
        }
        
        guard let rawJson = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else  {
                throw MoyaError.jsonMapping(self)
        }
        guard let ret = JSONDeserializer<T>.deserializeFrom(dict: rawJson) else {
            throw MoyaError.statusCode(self)
        }
        return ret
        
    }
}
