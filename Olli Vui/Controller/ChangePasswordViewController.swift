//
//  ChangePasswordViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 5/7/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD

class ChangePasswordViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet var overlapBnt : UIButton!
    @IBOutlet var updateBnt : UIButton!
    @IBOutlet var backBnt : UIButton!
    
    @IBOutlet var oldPassTf : UITextField!
    @IBOutlet var newPassTF : UITextField!
    @IBOutlet var reNewPassTF : UITextField!
    
    @IBOutlet var oldPassView : UIView!
    @IBOutlet var newPassView : UIView!
    @IBOutlet var reNewPassView : UIView!
    
    var mainViewController : ViewController!
    var service : Services = Services()
    var passWordParam : Dictionary<String, Any> = [:]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.oldPassTf) {
            self.newPassTF.becomeFirstResponder()
        }
        else if(textField == self.newPassTF) {
            self.reNewPassTF.becomeFirstResponder()
        }
        else if(textField == self.reNewPassTF) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainViewController.currentIndexView = 4
        self.resetUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        self.updateBnt.layer.cornerRadius = 20
        self.oldPassView.layer.cornerRadius = 20
        self.newPassView.layer.cornerRadius = 20
        self.reNewPassView.layer.cornerRadius = 20
        self.oldPassView.layer.borderWidth = 0.5
        self.newPassView.layer.borderWidth = 0.5
        self.reNewPassView.layer.borderWidth = 0.5
        self.oldPassView.layer.borderColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        self.newPassView.layer.borderColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        self.reNewPassView.layer.borderColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
    }
    func setUpData() {
        
    }
    func resetUI() {
        self.oldPassTf.text = ""
        self.newPassTF.text = ""
        self.reNewPassTF.text = ""
    }
    
    func validationEmptyTextF() -> Bool {
        if(self.oldPassTf.text == "" || self.newPassTF.text == "" || self.reNewPassTF.text == "") {
            return false
        }
        return true
    }
    func validationNewPassword() -> Bool {
        if(self.newPassTF.text != self.reNewPassTF.text) {
            return false
        }
        return true
    }
    func validationOldPassword() ->Bool {
        if(UserDefaults.standard.object(forKey: "passphase") != nil) {
            let oldPass = (UserDefaults.standard.object(forKey: "passphase") as! String)
            if(self.oldPassTf.text != oldPass) {
                return false
            }
        }
        return true
    }
    
    @IBAction func backAction(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func overlapAction(sender : Any) {
        self.oldPassTf.resignFirstResponder()
        self.newPassTF.resignFirstResponder()
        self.reNewPassTF.resignFirstResponder()
    }
    @IBAction func updateAction(sender : Any) {
        if(self.validationEmptyTextF() == false) {
            KRProgressHUD.set(deadlineTime: 0.5)
            KRProgressHUD.showMessage("Mật khẩu không thể bỏ trống")
        }
        else {
            if(self.validationOldPassword() == false) {
                KRProgressHUD.set(deadlineTime: 0.5)
                KRProgressHUD.showMessage("Mậtkhẩu cũ không đúng")
            }
            else {
                if(self.validationNewPassword()) {
                    // call  update service
                    KRProgressHUD.show()
                    self.passWordParam["newpassword"] = self.newPassTF.text
                    self.passWordParam["repeatnewpassword"] = self.reNewPassTF.text
                    self.service.HTTPRequestPutMethodWithToken(token: self.appDelegate.token, param: self.passWordParam, functionPath: "/users/updatepassword", completionHandler:{(data,respone,error) in
                        KRProgressHUD.dismiss()
                        let httpStatus = respone as? HTTPURLResponse
                        if(httpStatus?.statusCode != 200) {
                            KRProgressHUD.showMessage("loi \(String(describing: httpStatus?.statusCode))")
                        }
                        else {
                            DispatchQueue.main.async {
                                UserDefaults.standard.setValue(self.newPassTF.text, forKey: "passphase")
                            }
                            self.dismiss(animated: true , completion: nil)
                        }
                    })
                }
                else {
                    KRProgressHUD.set(deadlineTime: 1.5)
                    KRProgressHUD.showMessage("Mật khẩu mới không trủng khớp")
                }
            }
        }
    }
}
