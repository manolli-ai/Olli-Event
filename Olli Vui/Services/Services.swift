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
import FirebaseStorage
import NVActivityIndicatorView

class Services {
    public enum RESTMethod:String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
   
    let constant: ServicesConstant = ServicesConstant()
    func HTTPRequestPostMethod(param: Dictionary<String, Any>, functionPath: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
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
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    func HTTPRequestPostMethodWithToken(token: String, param: Dictionary<String, Any>, functionPath: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: constant.baseURL + constant.versionPath + functionPath)!)
        request.httpMethod = RESTMethod.post.rawValue //"POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: param as Any, options: [])
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            completionHandler(data, response,error)
        })
        task.resume()
    }
    func HTTPRequestGetMethodWithOnlyToken(token: String,functionPath: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: constant.baseURL + constant.versionPath + functionPath)!)
        request.httpMethod = RESTMethod.get.rawValue //"Get"
        request.addValue(token, forHTTPHeaderField: "Authorization")
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
    
    func HTTPRequestPutMethodWithToken(token: String,param: Dictionary<String, Any>, functionPath: String,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        KRProgressHUD.show()
        var request = URLRequest(url: URL(string: constant.baseURL + constant.versionPath + functionPath)!)
        request.httpMethod = RESTMethod.put.rawValue //"PUT"
        request.httpBody = try? JSONSerialization.data(withJSONObject: param as Any, options: [])
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            completionHandler(data, response,error)
        })
        task.resume()
        KRProgressHUD.dismiss()
    }
    
    func HTTPRequestGetMethod(token:String, param: Dictionary<String, Any>, functionPath: String, complettionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: constant.baseURL + constant.versionPath + functionPath)!)
        request.httpMethod = RESTMethod.get.rawValue//"GET"
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 20
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            complettionHandler(data,response,error)
        })
        task.resume()
    }
    func HTTPRequestPostUpLoadFileMethod(token:String,sid: String, gid: String, url:URL, functionPath: String) {
        KRProgressHUD.show()
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(url, withName: "audio")
             multipartFormData.append(sid.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "sid")
//            multipartFormData.append(Data.init(contentsOf: url), withName: "audio", mimeType: "audio/wave")
        }, usingThreshold: UInt64.init(),
           to: self.constant.baseURL + constant.versionPath + functionPath,
           method: HTTPMethod.post,
           headers: ["Authorization": token], encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    do {
                        KRProgressHUD.dismiss()
//                        debugPrint(response)
                         let json = try JSONSerialization.jsonObject(with: response.data!) as! Dictionary<String, AnyObject>
//                        debugPrint(json["errors"] as! Dictionary<String, Any>)
                        if(json["errors"] != nil) {
                            if(((json["errors"] as! Dictionary<String, Any>)["status"] as! NSNumber) == 200) {
                                self.DeleteFileWithURL(url: url)
                            }
                            else {
//                                KRProgressHUD.showMessage(((json["errors"] as! Dictionary<String, Any>)["message"] as! String))
                                KRProgressHUD.showMessage("upload file lỗi")
                            }
                        }
                    }
                    catch {
                        
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                KRProgressHUD.showMessage("upload file lỗi")
//                KRProgressHUD.showMessage(encodingError.localizedDescription)
            }
        })
//        self.uploadFileToFireBase(url: url, fileName: "\(url)")
    }
    
    func uploadFileToFireBase(url : URL, fileName : String) {
        let ref = Storage.storage().reference(withPath: "media").child(fileName)
        do {
            let data: Data = try Data.init(contentsOf: url)
            ref.putData(data)
        }
        catch {
            
        }
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }
    func DeleteFileWithURL(url: URL) {
        if(FileManager.default.fileExists(atPath: url.path)) {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            }
            catch {
                KRProgressHUD.showMessage(error as! String)
            }
            
        }
    }
}
extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
