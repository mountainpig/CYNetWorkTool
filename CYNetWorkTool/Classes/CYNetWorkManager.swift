//
//  CYNetWorkManager.swift
//  CYTest
//
//  Created by jing huang on 2024/3/18.
//

import UIKit
import Alamofire
import SwiftyJSON

public struct CYRequestModel {
    var method: HTTPMethod
    var url: String
    var headers: [String: String]?
    var parameters: [String: Any]?
    var timeoutInterval = 10
}

public struct CYResopnseModel {
    var dictionary: [String: Any]?
    var error: Error?
    var httpResponse: HTTPURLResponse?
}

open class CYNetWorkManager: NSObject {
    
    static let shared = CYNetWorkManager()

    class func request(model: CYRequestModel, completion: @escaping (CYResopnseModel) -> Void) {
        CYNetWorkManager.shared.request(model: model, completion: completion)
    }
    
    func request(model: CYRequestModel, completion: @escaping (CYResopnseModel) -> Void) {
        var headers: HTTPHeaders?
        if let modelHeader = model.headers {
            headers = HTTPHeaders(modelHeader)
        }
        self.request(model: model, header: headers, completion: completion)
    }
    
    func request(model: CYRequestModel, header:HTTPHeaders?, completion: @escaping (CYResopnseModel) -> Void) {
        let request = AF.request(model.url,method: model.method,parameters: model.parameters,headers:header) { urlRequest in
            urlRequest.timeoutInterval = TimeInterval(model.timeoutInterval)
        }
        request.responseDecodable(of: JSON.self) { response in
            var responseModel = CYResopnseModel(httpResponse: response.response)
            switch response.result {
            case .success(let value):
                responseModel.dictionary = JSON(value).dictionaryObject
            case .failure(let error):
                responseModel.error = error
            }
            completion(responseModel)
        }
    }
}

/*
extension CYNetWorkManager {
    
    func commonRequest(model: CYRequestModel, completion: @escaping (CYResopnseModel) -> Void) {
        var commonHeader = [String: String]()
        let userAgent = "weather" + "/" + UIDevice.current.appVersion + " (" + UIDevice.current.modelName + ";ios/" + UIDevice.current.systemVersion + ")"
        commonHeader["User-Agent"] = userAgent
        commonHeader["Device-Id"] = ""
        commonHeader["Accept-Language"] = ""
        commonHeader["Authorization"] = "Bearer " + "token"
        var headers = HTTPHeaders(commonHeader)
        if let addHeader = model.headers {
            for key in addHeader.keys {
                headers.add(name: key, value: addHeader[key] ?? "")
            }
        }
        request(model: model, header: headers, completion: completion)
    }
    
}
*/
