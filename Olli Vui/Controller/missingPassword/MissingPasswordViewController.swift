//
//  MissingPasswordViewController.swift
//  Olli Vui
//
//  Created by ManHuynh on 6/19/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD

class MissingPasswordViewController: UIViewController {
    @IBOutlet var updateBnt : UIButton!
    @IBOutlet var backBnt : UIButton!
    @IBOutlet var newPassTF : UITextField!
    @IBOutlet var reNewPassTF : UITextField!
    @IBOutlet var overlapBnt : UIButton!
    @IBOutlet var newPassView : UIView!
    @IBOutlet var reNewPassView : UIView!
    var service : Services = Services()
    var passWordParam : Dictionary<String, Any> = [:]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUpUI() {
        self.updateBnt.layer.cornerRadius = 20
        self.newPassView.layer.cornerRadius = 20
        self.reNewPassView.layer.cornerRadius = 20
        self.newPassView.layer.borderWidth = 0.5
        self.reNewPassView.layer.borderWidth = 0.5
        self.newPassView.layer.borderColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        self.reNewPassView.layer.borderColor = UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
    }
    func resetUI() {
        self.newPassTF.text = ""
        self.reNewPassTF.text = ""
    }
    func validationEmptyTextF() -> Bool {
        if(self.newPassTF.text == "" || self.reNewPassTF.text == "") {
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
    
    @IBAction func backAction(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func updateAction(sender : Any) {
        if(self.validationEmptyTextF() == false) {
            KRProgressHUD.set(deadlineTime: 0.5)
            KRProgressHUD.showMessage("Mật khẩu không thể bỏ trống")
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
                            sleep(1)
                            KRProgressHUD.set(deadlineTime: 1)
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
