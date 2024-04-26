//
//  CYNetWorkManager.swift
//  CYTest
//
//  Created by jing huang on 2024/3/18.
//

import UIKit
import Alamofire
import SwiftyJSON

@objc public enum CYRequestMehtod: Int {
    case get
    case post
    case put
    case delete
}

@objc public class CYRequestModel : NSObject {
    @objc public var method: CYRequestMehtod
    @objc public var url: String
    @objc public var headers: [String: String]?
    @objc public var parameters: [String: Any]?
    @objc public var timeoutInterval = 10
    
    @objc public init(method: CYRequestMehtod = .get,url: String,headers: [String: String]? = nil,parameters: [String: Any]? = nil,timeoutInterval : Int = 10){
        self.method = method
        self.url = url
        self.headers = headers
        self.parameters = parameters
        self.timeoutInterval = timeoutInterval
    }
    
    @objc public class func initWithUrl(_ urlStr:String) -> CYRequestModel {
        return CYRequestModel.init(url: urlStr)
    }
}

@objc public class CYResopnseModel : NSObject {
    @objc public var dictionary: [String: Any]?
    @objc public var array: [Any]?
    @objc public var error: Error?
    @objc public var httpResponse: HTTPURLResponse?
    
    @objc public init(dictionary: [String: Any]? = nil,array: [Any]? = nil,error: Error? = nil,httpResponse: HTTPURLResponse? = nil){
        self.dictionary = dictionary
        self.array = array
        self.error = error
        self.httpResponse = httpResponse
    }
}

@objc open class CYNetWorkManager: NSObject {
    
    @objc public static let shared = CYNetWorkManager()

    @objc public class func request(model: CYRequestModel, completion: @escaping (CYResopnseModel) -> Void) {
        CYNetWorkManager.shared.request(model: model, completion: completion)
    }
    
    @objc public func request(model: CYRequestModel, completion: @escaping (CYResopnseModel) -> Void) {
        var headers: HTTPHeaders?
        if let modelHeader = model.headers {
            headers = HTTPHeaders(modelHeader)
        }
        self.request(model: model, header: headers, completion: completion)
    }
    
    public func request(model: CYRequestModel, header:HTTPHeaders?, completion: @escaping (CYResopnseModel) -> Void) {
        var method = HTTPMethod.get
        if model.method == .post {
            method = .post
        } else if model.method == .put {
            method = .put
        } else if model.method == .delete {
            method = .delete
        }
        let request = AF.request(model.url,method: method,parameters: model.parameters,headers:header) { urlRequest in
            urlRequest.timeoutInterval = TimeInterval(model.timeoutInterval)
        }
        request.responseDecodable(of: JSON.self) { response in
            let responseModel = CYResopnseModel(httpResponse: response.response)
            switch response.result {
            case .success(let value):
                responseModel.dictionary = JSON(value).dictionaryObject
                responseModel.array = JSON(value).arrayObject
            case .failure(let error):
                responseModel.error = error
            }
            completion(responseModel)
        }
    }
}
