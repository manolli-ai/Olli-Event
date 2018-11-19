//
//  RegisterViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/27/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import RestKit
import KRProgressHUD
import JWT
import JWTDecode
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var phoneNumberView : UIView!
    @IBOutlet var registerBnt : UIButton!
    @IBOutlet var phoneNumberTf : UITextField!
    @IBOutlet var loginBnt : UIButton!
    @IBOutlet var overlapBnt : UIButton!
    @IBOutlet var newLoginBnt : UIButton!
    var mainView: ViewController!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userData: UsersData = UsersData()
    var user: Users = Users()
    let services:Services = Services()
    let dataconnector:UsersData = UsersData()
    let utility : Utility = Utility()
//    let mainView: ViewController = ViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
//        sleep(1)
//        KRProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpUI() {
        self.phoneNumberView.layer.cornerRadius = 20
        self.phoneNumberView.layer.borderWidth = 0.5
        self.phoneNumberView.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        self.registerBnt.layer.cornerRadius = 20
        self.newLoginBnt.layer.cornerRadius = 20
        self.newLoginBnt.layer.borderWidth = 0.5
        self.newLoginBnt.layer.borderColor = UIColor.init(red: 118/255, green: 147/255, blue: 221/255, alpha: 1).cgColor
    }
    func showFirstView() {
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
            if(self.userData.checkExitData()) {
                let user : Users = self.userData.fetchUserPhoneNumber(phoneNumber: "+84" + self.utility.validationPhoneNumber(phoneNumber: self.phoneNumberTf.text!))
                if(Int(user.isprofileupdated!)! == 1) { //updated
                    self.appDelegate.appstate = .online
                    self.appDelegate.myName = user.fullname!
                    self.appDelegate.myPhoneNumber = self.phoneNumberTf.text!
                    if(user.gender != nil) {
                        self.appDelegate.gender = Int(user.gender!)!
                    }
                    self.gotoMainView(sender: self.loginBnt)
                }
                else if(Int(user.isprofileupdated!)! == 3) { // not yet updated
                    //present firstView
                    let firstView : FirstViewController = FirstViewController()
                    firstView.parentView = self
                    self.present(firstView, animated: true, completion: {
                    })
                }
            }
        }
    }
    public func dismissLoginView(){
        DispatchQueue.main.async {
            self.appDelegate.appstate = .online
            if(self.mainView != nil) {
                self.mainView.currentUserEmail = self.phoneNumberTf.text
                self.gotoMainView(sender: self.loginBnt)
            }
        }
    }
    
    func registerWithoutVerify() {
//        KRProgressHUD.show()
        self.services.HTTPRequestPostMethod(param: ["mobilenumber": "+84" + self.utility.validationPhoneNumber(phoneNumber: self.phoneNumberTf.text!)],functionPath: "/users/verify/sms", completionHandler: { (data,response,error) in
//            KRProgressHUD.dismiss()
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let jwtString = json[json.index(forKey: "data")!].value["AuthToken"]
                if(jwtString != nil) {
                    do {
                        let claims = try decode(jwt: jwtString as! String)
                        self.dataconnector.AddUser(user: claims.body["sub"] as! Dictionary<String, Any>,token:jwtString as! String)
                        
                        self.showFirstView()
                    }catch {
//                        KRProgressHUD.showMessage((error.localizedDescription))
                    }
                }
                else {
//                    KRProgressHUD.set(deadlineTime: 1.5)
//                    KRProgressHUD.showMessage("Lỗi không xác định")
//                    sleep(1)
                }
            }
            catch {
            }
        })
    }
    
    func authen() {
        PhoneAuthProvider.provider().verifyPhoneNumber("+84" + self.utility.validationPhoneNumber(phoneNumber: self.phoneNumberTf.text!), uiDelegate: nil) { (verificationID, error) in
            if error != nil {
//                KRProgressHUD.set(deadlineTime: 1.5)
//                KRProgressHUD.showMessage((error?.localizedDescription)!)
                return
            }
            else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                let alert = UIAlertController.init(title: "Vui lòng nhập mã xác thực vừa được gửi đến số điện thoại của bạn", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        if  alert.textFields?.first?.text != "" {
                            
                            let credential = PhoneAuthProvider.provider().credential(
                                withVerificationID: verificationID!,
                                verificationCode: (alert.textFields?.first?.text)!)
                            Auth.auth().signIn(with: credential) { (user, error) in
                                
                                if error != nil {
//                                    KRProgressHUD.set(deadlineTime: 1.5)
//                                    KRProgressHUD.showMessage("Mã xác nhận chưa đúng hoặc có lỗi kết nối. Bạn vui lòng thử lại")
                                    return
                                }
//                                KRProgressHUD.show()
                                user!.getIDToken(completion: { (id, error) in
                                    self.services.HTTPRequestPostMethod(param: ["token": id!],functionPath: "/users/verify/sms", completionHandler: { (data,response,error) in
//                                            KRProgressHUD.dismiss()
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                                            let jwtString = json[json.index(forKey: "data")!].value["AuthToken"]
                                            do {
                                                if(jwtString != nil) {
                                                    let claims = try decode(jwt: jwtString as! String)
                                                    self.dataconnector.AddUser(user: claims.body["sub"] as! Dictionary<String, Any>,token:jwtString as! String)
//                                                    KRProgressHUD.dismiss()
                                                    self.showFirstView()
                                                }
                                            }catch {
//                                                KRProgressHUD.showMessage((error.localizedDescription))
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
    
    @IBAction func registerAction(sender: Any) {
//        KRProgressHUD.show()
        self.phoneNumberTf.resignFirstResponder()
        if self.phoneNumberTf.text != "" {
             let user : Users = self.userData.fetchUserPhoneNumber(phoneNumber: "\("+84" + self.utility.validationPhoneNumber(phoneNumber: self.phoneNumberTf.text!))")
            if(self.userData.CheckExitPhoneNumber(phoneNumber: "\("+84" + self.utility.validationPhoneNumber(phoneNumber: self.phoneNumberTf.text!))")) {
                if(user.oauthaccesstoken != nil && user.oauthaccesstoken != "") {
                    self.appDelegate.token = user.oauthaccesstoken!
//                    KRProgressHUD.dismiss()
                    self.showFirstView()
                }
            }
            else {
//                 KRProgressHUD.dismiss()
                self.authen()
//                self.registerWithoutVerify()
            }
        }
        else {
//            KRProgressHUD.set(deadlineTime: 1.5)
//            KRProgressHUD.showMessage("Số điện thoại không thể trống")
        }
    }
    @IBAction func gotoLoginView(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func hidekeyboard(sender : Any) {
        self.phoneNumberTf.resignFirstResponder()
    }
    @IBAction func gotoMainView(sender: Any) {
        KRProgressHUD.dismiss()
        var controller = presentingViewController
        while let presentingVC = controller?.presentingViewController {
            controller = presentingVC
        }
        controller?.dismiss(animated: true)
    }
    
    @IBAction func clearKeyboard(sender: Any) {
        self.phoneNumberTf.resignFirstResponder()
    }
}
