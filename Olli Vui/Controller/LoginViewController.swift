//
//  LoginViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/4/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import RestKit
import KRProgressHUD
import JWT
import JWTDecode

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var registerView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var emailtxf: UITextField!
    @IBOutlet var passwordtxf: UITextField!
    @IBOutlet var togle: UIImageView!
     @IBOutlet var loginTabButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
     @IBOutlet var registerTabButton: UIButton!
    @IBOutlet var faceBookButton:UIButton!
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var fullNametfx: UITextField!
    @IBOutlet var emailRegistertxf: UITextField!
    @IBOutlet var passtxf: UITextField!
    @IBOutlet var repeatPasstxf: UITextField!

    var mainView: ViewController!
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.validationText()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.emailtxf) {
            self.passwordtxf.becomeFirstResponder()
        } else if(textField == self.passwordtxf) {
            textField.resignFirstResponder()
        }  else if(textField == self.fullNametfx) {
            self.emailRegistertxf.becomeFirstResponder()
        }
        else if(textField == self.emailRegistertxf) {
            self.passtxf.becomeFirstResponder()
        }
        else if(textField == self.passtxf) {
            self.repeatPasstxf.becomeFirstResponder()
        }
        else if(textField == self.repeatPasstxf) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    let services:Services = Services()
    let dataconnector:UsersData = UsersData()
    var dict : [String : AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailtxf.delegate = self
        self.passwordtxf.delegate = self
        self.fullNametfx.delegate = self
        self.emailRegistertxf.delegate = self
        self.passtxf.delegate = self
        self.repeatPasstxf.delegate = self
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.green
        self.loginButton.layer.cornerRadius = 30.0
        self.faceBookButton.layer.cornerRadius = 35.0
        self.googleButton.layer.cornerRadius = 35.0
        //set togle at default
        self.animatedTogleAtLogin()
//        self.animatedTogleAtRegister()
       self.validationText()
    }
    func validationText() {
        if(self.emailtxf.text != "" && self.passwordtxf.text != "" ) {
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = UIColor.init(red: 57/255, green: 197/255, blue: 243/255, alpha: 1)
        } else {
            self.loginButton.isEnabled = false
//            self.loginButton.backgroundColor = UIColor.gray
        }
    }
    func clearKeyBoard(){
        self.emailtxf.resignFirstResponder()
        self.passwordtxf.resignFirstResponder()
        self.emailRegistertxf.resignFirstResponder()
        self.fullNametfx.resignFirstResponder()
        self.passtxf.resignFirstResponder()
        self.repeatPasstxf.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func LoginTabpressed (sender: AnyObject) {
        self.animatedTogleAtLogin()
    }
    @IBAction func RegisterTabpressed (sender: AnyObject) {
        self.animatedTogleAtRegister()
    }

    func animatedTogleAtLogin() {
        self.togle.frame = CGRect.init(x: (self.loginTabButton.frame.origin.x + self.loginTabButton.frame.width/2) - 8.0, y: (self.loginTabButton.frame.origin.y + self.loginTabButton.frame.size.height) - 8.0, width: 15, height: 15)
        self.loginView.isHidden = false
        self.registerView.isHidden = true
    }
    func animatedTogleAtRegister() {
         self.togle.frame = CGRect.init(x: (self.registerTabButton.frame.origin.x + self.registerTabButton.frame.width/2) - 8.0, y: (self.registerTabButton.frame.origin.y + self.registerTabButton.frame.size.height) - 8.0, width: 15, height: 15)
        self.loginView.isHidden = true
        self.registerView.isHidden = false
    }
    
    @IBAction func login(sender: AnyObject) {
        self.clearKeyBoard()
        KRProgressHUD.show()
        self.services.HTTPRequestPostMethod(param: ["email":self.emailtxf.text, "password" : self.passwordtxf.text], functionPath: "/users/login/email", completionHandler: {(data, response,error) in
            let httpResponse = response as? HTTPURLResponse
            if(httpResponse?.statusCode == 200) {
                do {
                        DispatchQueue.main.async {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.appstate = .online
                        }
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    let jwtString = json[json.index(forKey: "response")!].value["AuthToken"]
                    do {
                        let claims = try decode(jwt: jwtString as! String)
                        self.dataconnector.AddUser(user: claims.body["sub"] as! Dictionary<String,String>,token:jwtString as! String)
                    }catch {
                        print(error)
                    }
                    print(json)
                } catch {
                    print("error")
                }
                KRProgressHUD.dismiss()
                self.dismissLoginView()
            } else {
//                TODO show error code
            }
           
        })
    }
    func dismissLoginView(){
        DispatchQueue.main.async {
            self.mainView.currentUserEmail = self.emailtxf.text
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func FBlogin(sender : AnyObject) {
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
            return
        }
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        //                        self.fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
//            print("check login status \(FBSDKAccessToken.current().tokenString)")
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
//                  test mock
                    let temp: Dictionary<String, Any> = ["email": "\(self.dict[self.dict.index(forKey: "email")!].value)",
                        "password": [
                            "oauthUid":"",
                            "oauthAccessToken" : "\(FBSDKAccessToken.current().tokenString)",
                            "oauthInfo": [
                                "id" : "\(self.dict[self.dict.index(forKey: "id")!].value)",
                                "email": "\(self.dict[self.dict.index(forKey: "email")!].value)",
                                "name": "\(self.dict[self.dict.index(forKey: "name")!].value)",
                                "first_name": "\(self.dict[self.dict.index(forKey: "first_name")!].value)",
                                "last_name": "\(self.dict[self.dict.index(forKey: "last_name")!].value)",
                                "gender": "\(self.dict[self.dict.index(forKey: "gender")!].value)",
                                "picture": [
                                    "data": [
                                        "url": "https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/15977913_10210882023502084_6865895702925001643_n.jpg?oh=66bc7282906dc5ff89b0c823b096b220&oe=5AFCD214"
                                    ]
                                ]
                            ]
                        ]
                    ]
//                    self.callserverWithHTTP(param: temp)

                    self.services.HTTPRequestPostMethod(param: temp,functionPath:"/users/login/facebook", completionHandler: { (data, response,error) in
                        let httpResponse = response as? HTTPURLResponse
                        if(httpResponse?.statusCode == 200) {
                            do {
                                DispatchQueue.main.async {
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    appDelegate.appstate = .online
                                }
                                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                let jwtString = (json["response"] as! Dictionary<String, AnyObject>)["AuthToken"]
                                do {
                                    let claims = try decode(jwt: jwtString as! String)
                                    self.mainView.currentUserEmail = (claims.body["sub"] as! Dictionary<String,Any>)["email"] as! String
                                    self.dataconnector.AddUser(user: claims.body["sub"] as! Dictionary<String,Any>,token:jwtString as! String)
                                    self.dismissLoginView()
                                }catch {
                                    print(error)
                                }
                                print(json)
                            } catch {
                                print("error")
                            }
                            KRProgressHUD.dismiss()
                            
                        } else {
                            //                TODO show error code
                        }
                    })
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    func callserverWithHTTP(param: Dictionary<String, Any>) {
        var request = URLRequest(url: URL(string: "https://vui.olli.vn/api/v1/users/login/facebook")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: param as Any, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print("\(json[json.index(forKey: "response")!].value["AuthToken"])")
            } catch {
                print("error")
            }
        })
        task.resume()
    }
    func callserWithRestKit() {
        let responseMapping: RKObjectMapping = RKObjectMapping.init(for: NewAccount.self)
        responseMapping.addAttributeMappings(from: ["fullname","email","password","repeatpassword"])
//        let statusCode: NSIndexSet = RKStatusCodeIndexSetForClass(RKStatusCodeClass.successful)! as NSIndexSet
//        let newAccountDescriptor: RKResponseDescriptor = RKResponseDescriptor.init(mapping: responseMapping, method: RKRequestMethod.any, pathPattern: nil, keyPath: nil, statusCodes: statusCode as IndexSet!)
        let requestMapping: RKObjectMapping = RKObjectMapping.request()
        requestMapping.addAttributeMappings(from: ["fullname", "email", "password", "repeatpassword"])
        let requestDecriptor: RKRequestDescriptor = RKRequestDescriptor.init(mapping: requestMapping, objectClass: NewAccount.self, rootKeyPath: nil, method: RKRequestMethod.any)
        let requestManager: RKObjectManager = RKObjectManager.init(baseURL: URL.init(string: "https://vui.olli.vn"))
        requestManager.addRequestDescriptor(requestDecriptor)
        let postObject: NewAccount = NewAccount.init(fullname: "man", email: "minhman000001@gmai.com", password: "1234567")
        requestManager.post(postObject, path: "/api/v1/users/register", parameters: nil , success: { (operation, mappingResult) -> Void in
            print("kiem tra du lieu tra ve  ")
        }, failure: nil)
    }
    func callPostRestKit() {
        let responseMapping: RKObjectMapping = RKObjectMapping.init(for: Questions.self)
//        responseMapping.addAttributeMappings(from: ["records"])
        let statusCode: NSIndexSet = RKStatusCodeIndexSetForClass(RKStatusCodeClass.successful)! as NSIndexSet //https://vui.olli.vn/api/v1/games/
        let resDesCriptor = RKResponseDescriptor.init(mapping: responseMapping, method: RKRequestMethod.GET, pathPattern: "/api/v1/games/", keyPath: nil, statusCodes: statusCode as IndexSet!)
        let url = NSURL.init(string: "https://vui.olli.vn")
        let requestManager: RKObjectManager = RKObjectManager.init(baseURL: url! as URL)
        requestManager.httpClient.setDefaultHeader("Authorization", value: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJlbWFpbCIsInN1YiI6eyJpZCI6IjEiLCJzY3JlZW5uYW1lIjoiQWRtaW5pc3RyYXRvciIsImZ1bGxuYW1lIjoiQWRtaW5pc3RyYXRvciIsImVtYWlsIjoiYWRtaW5AbG9jYWxob3N0LmxvY2FsIiwiYWRkcmVzcyI6IiIsInBhc3N3b3JkIjoiIiwiZ3JvdXBpZCI6ImFkbWluaXN0cmF0b3IiLCJhdmF0YXIiOiIiLCJnZW5kZXIiOiJtYWxlIiwic3RhdHVzIjoiMSIsImRvYiI6bnVsbCwib2F1dGh1aWQiOiIiLCJvYXV0aGFjY2Vzc3Rva2VuIjoiIiwib2F1dGhwcm92aWRlciI6IiIsIm9uZXNpZ25hbGlkIjoiIiwic3RhdGUiOiIwIiwiZGF0ZWNyZWF0ZWQiOiIxNDk0NTYwNjk2IiwiZGF0ZWxhc3RjaGFuZ2VwYXNzd29yZCI6IjAiLCJkYXRlbW9kaWZpZWQiOiIxNTExNzc5ODcwIiwibW9iaWxlbnVtYmVyIjoiIiwiaXN2ZXJpZmllZCI6IjEiLCJ2ZXJpZnl0eXBlIjoiMSJ9LCJpYXQiOjE1MTE4NTUzMjcsImV4cCI6MTU0Nzg1NTMyN30.vz80gczJSUE8D1p4imK2P_eU3lZRnpRKho5f9RMqWTc")
        requestManager.addResponseDescriptor(resDesCriptor)
        requestManager.getObjectsAtPath("/api/v1/games/", parameters: nil, success: {(operation, result) -> Void in
//            let rs: Questions = result?.firstObject as! Questions
            print("kiem tra action tra ve:\(result)")
        }, failure: nil)
    }
    
    func callChangePass() {
        let responseMapping: RKObjectMapping = RKObjectMapping.init(for: changePassResponse.self)
//        responseMapping.addAttributeMappings(from: <#T##[Any]!#>)
        let statusCode: NSIndexSet = RKStatusCodeIndexSetForClass(RKStatusCodeClass.successful)! as NSIndexSet
        let responseDecriptor: RKResponseDescriptor = RKResponseDescriptor.init(mapping: responseMapping, method: RKRequestMethod.any, pathPattern: "/api/v1/users/forgotpassword", keyPath: nil, statusCodes: statusCode as IndexSet!)
        let requestMapping: RKObjectMapping = RKObjectMapping.request()
        requestMapping.addAttributeMappings(from: ["email"])
//        requestMapping.ad
        let requestDecriptor: RKRequestDescriptor = RKRequestDescriptor.init(mapping: requestMapping, objectClass: changePassRequest.self, rootKeyPath: nil, method: RKRequestMethod.any)
        
        let requestManager: RKObjectManager = RKObjectManager.init(baseURL: URL.init(string: "https://vui.olli.vn"))
        requestManager.addResponseDescriptor(responseDecriptor)
        requestManager.addRequestDescriptor(requestDecriptor)
        let object:changePassRequest = changePassRequest.init(email: "man@olli-ai.com")
        requestManager.post(object, path: "/api/v1/users/forgotpassword", parameters: nil, success: {(operation, result) -> Void in
            print("kiem tra du lieu tra ve \(result)")
        }, failure: nil)
        
    }
    
    @IBAction func RegisterAction(sender: AnyObject) {
        self.services.HTTPRequestPostMethod(param: ["fullname":self.fullNametfx.text as Any, "email":self.emailRegistertxf.text  as Any,"password":self.passtxf.text as Any, "repeatpassword":self.repeatPasstxf.text as Any],
                                            functionPath: "/users/register", completionHandler: { (data,response,error) in
                let httpResponse = response as? HTTPURLResponse
                if(httpResponse?.statusCode == 200) {
                    do {
                        DispatchQueue.main.async {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.appstate = .online
                        }
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        let jwtString = json[json.index(forKey: "response")!]
                        print(jwtString)
                        do {
//                            let claims = try decode(jwt: jwtString as! String)
//                            self.dataconnector.AddUser(user: claims.body["sub"] as! Dictionary<String,String>,token:jwtString as! String)
                        }catch let error {
                            print(error)
                        }
                        print(json)
                    } catch {
                        print("error")
                    }
                    KRProgressHUD.dismiss()
                    self.dismissLoginView()
                } else {
                    //TODO show error code
                }
        })
    }
}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
extension UIView {
    // Name this function in a way that makes sense to you...
    // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
    func slideInFromLeft(duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = (delegate as! CAAnimationDelegate)
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
}
