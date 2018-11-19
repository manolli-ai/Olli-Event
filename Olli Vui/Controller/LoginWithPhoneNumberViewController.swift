//
//  LoginWithPhoneNumberViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/27/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD
import JWT
import JWTDecode
import Firebase

class LoginWithPhoneNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var phoneNumerView : UIView!
    @IBOutlet var passView : UIView!
    @IBOutlet var loginBnt : UIButton!
    @IBOutlet var registerBnt : UIButton!
    @IBOutlet var phoneNumberTf : UITextField!
    @IBOutlet var passTf : UITextField!
    @IBOutlet var hidePassBnt : UIButton!
//    @IBOutlet var 
    let registerView : RegisterViewController = RegisterViewController()
    var mainViewController: ViewController!
    let services:Services = Services()
    let userData: UsersData = UsersData()
    let dataconnector:UsersData = UsersData()
    let utility : Utility = Utility()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var user : Users = Users()
    var missingPassView : MissingPasswordViewController = MissingPasswordViewController()
    var param : Dictionary<String, Any> = [:]
    var hidenPass : Bool!
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.passTf) {
            textField.resignFirstResponder()
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.hidenPass = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetUI()
        self.initData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.autoLogin()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KRProgressHUD.dismiss()
//        self.appDelegate.myPhoneNumber = self.phoneNumberTf.text!
    }
    func resetUI () {
        self.passTf.text = ""
    }
    func initData() {
        if(self.userData.checkExitData()) {
            self.user = self.userData.fetchUser()
            self.appDelegate.user = self.user
        }
        self.setUpData()
    }
    func setUpData() {
        if(self.userData.checkExitData()) {
            let phoneNumber = self.utility.convertPhoneNumberToShortForm(phoneNumber: self.user.mobilenumber!)
            self.appDelegate.myPhoneNumber = phoneNumber
            DispatchQueue.main.async {
                self.phoneNumberTf.text = phoneNumber
                if(UserDefaults.standard.object(forKey: "passphase") != nil) {
                    self.passTf.text = (UserDefaults.standard.object(forKey: "passphase") as! String)
                }
            }
            if(self.user.fullname != nil) {
                self.appDelegate.myName = self.user.fullname!
            }
            self.getProfileFromService()
        }
    }
    
    func getProfileFromService() {
//        KRProgressHUD.show()
        self.services.HTTPRequestGetMethodWithOnlyToken(token: self.appDelegate.token, functionPath: "/users/profile", completionHandler: {(data,respone,error) in
            if(data != nil) {
//                KRProgressHUD.dismiss()
                if let httpStatus = respone as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    KRProgressHUD.showMessage("lỗi \(httpStatus.statusCode)")
                    return
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    //                print(json["data"] as! NSDictionary)
                    let gender : Int = Int((((((((json["data"] as! NSDictionary)["profile"]) as! NSDictionary)["data"]) as! NSDictionary)["gender"]) as! NSDictionary)["value"] as! Int)
                    self.appDelegate.gender = gender
                    self.userData.UpdateUser(key: "gender", value: String(gender))
                    //                let dob = Double(((((((json["data"] as! NSDictionary)["profile"]) as! NSDictionary)["data"]) as! NSDictionary)["dob"]) as! Double)
                    //                let voiceregion = Int(((((((json["data"] as! NSDictionary)["profile"]) as! NSDictionary)["data"]) as! NSDictionary)["voiceregion"]) as! Int)
                    
                }
                catch {
                    
                }
            }
        })
    }
    
    func autoLogin() {
        if(self.passTf.text != "" && UserDefaults.standard.bool(forKey: "autoLogin") == true) {
            self.loginAction(sender: self.loginBnt)
        }
    }
    func setUpUI() {
        self.phoneNumerView.layer.cornerRadius = 20
        self.passView.layer.cornerRadius = 20
        self.phoneNumerView.layer.borderWidth = 0.5
        self.passView.layer.borderWidth = 0.5
        self.phoneNumerView.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        self.passView.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        self.loginBnt.layer.cornerRadius = 20
        self.registerBnt.layer.cornerRadius = 20
        self.registerBnt.layer.borderWidth = 0.5
        self.registerBnt.layer.borderColor = UIColor.init(red: 118/255, green: 147/255, blue: 221/255, alpha: 1).cgColor
    }
    func clearKeyBoard(){
        self.phoneNumberTf.resignFirstResponder()
        self.passTf.resignFirstResponder()
    }
    @IBAction func gotoRegisterView(sender : Any) {
        self.registerView.mainView = self.mainViewController
        self.present(self.registerView, animated: true, completion: nil)
    }

    @IBAction func loginAction(sender : Any) {
        self.clearKeyBoard()
        self.param["username"] = self.utility.convertPhoneNumberToFullFormat(phoneNumber: self.utility.validationPhoneNumber(phoneNumber: self.phoneNumberTf.text!))
        self.param["password"] = self.passTf.text
//        KRProgressHUD.show()
        self.services.HTTPRequestPostMethod(param: self.param, functionPath: "/users/login/phone", completionHandler: {(data, respone, eorror) in
            do {
//                 KRProgressHUD.dismiss()
                let httpStatus = respone as? HTTPURLResponse
                    if(data != nil) {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                            if(httpStatus?.statusCode == 200) {
                            DispatchQueue.main.async {
                                UserDefaults.standard.setValue(self.passTf.text, forKey: "passphase")
                            }
                            //check if user is exit-- if not add(user)
                            
                            let jwtString = json[json.index(forKey: "data")!].value["AuthToken"]
                            do {
                                let claims = try decode(jwt: jwtString as! String)
                                self.dataconnector.AddUser(user: claims.body["sub"] as! Dictionary<String, Any>,token:jwtString as! String)
                                self.appDelegate.appstate = .online
                                if(self.userData.checkExitData()) {
                                    self.user = self.userData.fetchUser()
                                    self.appDelegate.user = self.user
                                }
                                 self.setUpData()
                                self.dismiss(animated: true, completion: {
                                    self.mainViewController.getSynTotalScore()
                                })
                            }catch {
                                KRProgressHUD.showMessage((error.localizedDescription))
                            }
                            UserDefaults.standard.set(true, forKey: "autoLogin")
                        }
                            else {
                                sleep(1)
                                KRProgressHUD.set(deadlineTime: 2)
                                if(((json["errors"] as! Dictionary<String, Any>)["code"] as! Int) == 3003) {
                                    KRProgressHUD.showMessage("Tài khoản chưa xác thực hoặc sai mật khẩu")
                                }
                                else {
                                    KRProgressHUD.showMessage("Lỗi ...")
                                }
//                                print((json["errors"] as! Dictionary<String, Any>))
//                                KRProgressHUD.showMessage(((json["errors"] as! Dictionary<String, Any>)["message"] as! String))
                        }
                    }
            }
            catch {
            }
            
        })
    }
    @IBAction func showHidePassAction(sender: Any) {
        if(self.hidenPass == true) {
            self.passTf.isSecureTextEntry = false
            self.hidenPass = false
        }
        else {
            self.passTf.isSecureTextEntry = true
            self.hidenPass = true
        }
    }
    
    @IBAction func clearKeyboard(sender : Any) {
        self.phoneNumberTf.resignFirstResponder()
        self.passTf.resignFirstResponder()
    }
    @IBAction func missingPassAction(sender : Any) {
        if(self.validationPhoneNumber()) {
            PhoneAuthProvider.provider().verifyPhoneNumber("+84" + self.utility.validationPhoneNumber(phoneNumber: self.phoneNumberTf.text!), uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    KRProgressHUD.set(deadlineTime: 1.5)
                    KRProgressHUD.showMessage((error?.localizedDescription)!)
                    return
                }
                else {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    let alert = UIAlertController.init(title: "Vui lòng nhập mã xác thực vừa được gửi đến số điện thoại của bạn", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            if  alert.textFields?.first?.text != "" {
//                                KRProgressHUD.show()
                                let credential = PhoneAuthProvider.provider().credential(
                                    withVerificationID: verificationID!,
                                    verificationCode: (alert.textFields?.first?.text)!)
                                Auth.auth().signIn(with: credential) { (user, error) in
                                    if error != nil {
                                        KRProgressHUD.set(deadlineTime: 1.5)
                                        KRProgressHUD.showMessage("Mã xác nhận chưa đúng hoặc có lỗi kết nối. Bạn vui lòng thử lại")
                                        return
                                    }
                                    
                                    user!.getIDToken(completion: { (id, error) in
                                        self.services.HTTPRequestPostMethod(param: ["token": id!],functionPath: "/users/verify/sms", completionHandler: { (data,response,error) in
                                            do {
                                                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                                let jwtString = json[json.index(forKey: "data")!].value["AuthToken"]
                                                self.appDelegate.token = jwtString as! String
                                                
                                                do {
                                                    if(jwtString != nil) {
                                                        let claims = try decode(jwt: jwtString as! String)
                                                        self.dataconnector.AddUser(user: claims.body["sub"] as! Dictionary<String, Any>,token:jwtString as! String)
                                                        DispatchQueue.main.async {
                                                            self.present(self.missingPassView, animated: true, completion: {
                                                            })
                                                        }
                                                    }
                                                }catch {
                                                    KRProgressHUD.showMessage((error.localizedDescription))
                                                }
                                                
                                            }
                                            catch {
                                            }
                                        })
                                    })
                                    
                                    
                                }
                            }
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    alert.addTextField { (textField) in
                        textField.placeholder = "Mã xác thực (gồm 6 chữ số)"
                        textField.keyboardType = .decimalPad
                    }
                    let customView : UIViewController = UIViewController()
                    customView.view.frame = CGRect.init(x: 0, y: 0, width: 60, height: 100)
                    customView.view.backgroundColor = .red
                    alert.addChildViewController(customView)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func validationPhoneNumber() -> Bool {
        if(self.phoneNumberTf.text == "")
        {
            sleep(1)
            KRProgressHUD.set(deadlineTime: 1)
            KRProgressHUD.showMessage("Số điện thoại không thể trống")
            return false
        }
        else {
            return true
        }
    }
}
