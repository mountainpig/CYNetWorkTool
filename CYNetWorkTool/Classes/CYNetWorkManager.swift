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
    public var method: HTTPMethod
    public var url: String
    public var headers: [String: String]?
    public var parameters: [String: Any]?
    public var timeoutInterval = 10
    
    public init(method: HTTPMethod = .get,url: String,headers: [String: String]? = nil,parameters: [String: Any]? = nil,timeoutInterval : Int = 10){
        self.method = method
        self.url = url
        self.headers = headers
        self.parameters = parameters
        self.timeoutInterval = timeoutInterval
    }
}

public struct CYResopnseModel {
    public var dictionary: [String: Any]?
    public var error: Error?
    public var httpResponse: HTTPURLResponse?
    
    public init(dictionary: [String: Any]? = nil,error: Error? = nil,httpResponse: HTTPURLResponse? = nil){
        self.dictionary = dictionary
        self.error = error
        self.httpResponse = httpResponse
    }
}

open class CYNetWorkManager: NSObject {
    
    public static let shared = CYNetWorkManager()

    public class func request(model: CYRequestModel, completion: @escaping (CYResopnseModel) -> Void) {
        CYNetWorkManager.shared.request(model: model, completion: completion)
    }
    
    public func request(model: CYRequestModel, completion: @escaping (CYResopnseModel) -> Void) {
        var headers: HTTPHeaders?
        if let modelHeader = model.headers {
            headers = HTTPHeaders(modelHeader)
        }
        self.request(model: model, header: headers, completion: completion)
    }
    
    public func request(model: CYRequestModel, header:HTTPHeaders?, completion: @escaping (CYResopnseModel) -> Void) {
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
