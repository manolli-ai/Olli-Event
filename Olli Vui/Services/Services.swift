//
//  Services.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/5/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
import RestKit
import KRProgressHUD
import Alamofire
class Services {
    public enum RESTMethod:String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    let constant: ServicesConstant = ServicesConstant()
    func HTTPRequestPostMethod(param: Dictionary<String, Any>, functionPath: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: constant.baseURL + constant.versionPath + functionPath)!)
        request.httpMethod = RESTMethod.post.rawValue //"POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: param as Any, options: [])
//        request.allHTTPHeaderFields = ["application/json":"Content-Type",]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            completionHandler(data, response,error)
        })
        task.resume()
    }
    func HTTPRequestPutMethod(param: Dictionary<String, Any>, functionPath: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: constant.baseURL + constant.versionPath + functionPath)!)
        request.httpMethod = RESTMethod.put.rawValue //"PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: param as Any, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            completionHandler(data, response,error)
        })
        task.resume()
    }
    func HTTPRequestGetMethod(token:String, param: Dictionary<String, Any>, functionPath: String, complettionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: constant.baseURL + constant.versionPath + functionPath)!)
        request.httpMethod = RESTMethod.get.rawValue//"GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            complettionHandler(data,response,error)
        })
        task.resume()
    }
    func HTTPRequestPostUpLoadFileMethod(token:String,sid: String, gid: String, url:URL, functionPath: String) {
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(url, withName: "audio")
            multipartFormData.append(gid.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "gid")
             multipartFormData.append(sid.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "sid")
        }, usingThreshold: UInt64.init(),
           to: self.constant.baseURL + constant.versionPath + functionPath,
           method: HTTPMethod.post,
           headers: ["Authorization": token], encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }
}
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
