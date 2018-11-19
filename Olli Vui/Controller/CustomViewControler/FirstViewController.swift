//
//  FirstViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/24/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD
class FirstViewController: UIViewController , UITextFieldDelegate, CustomPickerProtocol {
    func updateDefaultValuew(title: String) {
        print("")
    }
    
    func setTitleForItem(id: Int ,title: String) {
        if(self.pickerth == 1) {
            self.regionLB.text = title
            self.profileParam["voiceregion"] = id
        }
        else if(self.pickerth == 2) {
            self.dobLB.text = title
            self.profileParam["dob"] = "01/01/\(title)"
        }
    }

    @IBOutlet var updateBnt: UIButton!
    @IBOutlet var passTxf : UITextField!
    @IBOutlet var rePassTxf : UITextField!
    @IBOutlet var maleBnt : UIButton!
    @IBOutlet var feMaleBnt : UIButton!
    @IBOutlet var voiceregionBnt : UIButton!
    @IBOutlet var dobBnt : UIButton!
    @IBOutlet var regionLB : UILabel!
    @IBOutlet var dobLB : UILabel!
    @IBOutlet var passView : UIView!
    @IBOutlet var rePassVew : UIView!
    
    var parentView : RegisterViewController!
    let customPickerView : CustomPickerViewController = CustomPickerViewController()
    var gender = 0
    var voiceregion = 1
    var service : Services = Services()
    var profileParam : Dictionary<String, Any> = [:]
    var pickerth = 1
    var passWordParam : Dictionary<String, Any> = [:]
    
    let serviceConstant : ServicesConstant = ServicesConstant()
    let userData : UsersData = UsersData()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var region : NSArray = [""]
    let dob = ["1947","1948","1949","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006"]
    var pickerDataSource = [""]
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.passTxf) {
            if(self.passTxf.text != "") {
                self.passWordParam["newpassword"] = self.passTxf.text
                self.rePassTxf.becomeFirstResponder()
            }
            else {
                KRProgressHUD.set(deadlineTime: 1.5)
                KRProgressHUD.set(font: UIFont.systemFont(ofSize: 18, weight: .light)) //UIFontWeightLight
                KRProgressHUD.showMessage("Mật khẩu không thể rỗng")
            }
        } else if(textField == self.rePassTxf) {
            if(self.validationPass()) {
                self.passWordParam["repeatnewpassword"] = self.rePassTxf.text
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileParam["email"] = ""
        self.profileParam["fullname"] = ""
        self.profileParam["gender"] = 1
        self.profileParam["dob"] = "01/01/1988"
        self.profileParam["voiceregion"] = 1
        self.setUpUI()
        self.setUpDataSource()
        self.region = self.serviceConstant.initDataForProvince()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        KRProgressHUD.dismiss()
    }

    func validationPass() -> Bool {
        if(self.passTxf.text == "" || self.rePassTxf.text == "") {
            KRProgressHUD.set(deadlineTime: 1.5)
            KRProgressHUD.set(font: UIFont.systemFont(ofSize: 18, weight: .light))
            KRProgressHUD.showMessage("Mật khẩu không thể rỗng")
            return false
        }
        else if(self.passTxf.text != "" && self.rePassTxf.text != "" && self.passTxf.text != self.rePassTxf.text) {
            KRProgressHUD.set(deadlineTime: 1.5)
            KRProgressHUD.set(font: UIFont.systemFont(ofSize: 18, weight: .light))
            KRProgressHUD.showMessage("Mật khẩu không trùng khớp")
            return false
        }
        else if(self.passTxf.text != "" && self.rePassTxf.text != "" && self.passTxf.text == self.rePassTxf.text) {
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpDataSource() {
        self.customPickerView.delegate = self
    }
    
    func setUpUI() {
        self.passView.layer.cornerRadius = 20
        self.rePassVew.layer.cornerRadius = 20
        self.passView.layer.borderWidth = 0.5
        self.rePassVew.layer.borderWidth = 0.5
        self.passView.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        self.rePassVew.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        self.updateBnt.layer.cornerRadius = 20
    }
    
    func clearKeyboard() {
        self.passTxf.resignFirstResponder()
        self.rePassTxf.resignFirstResponder()
    }
    
    @IBAction func updateAction(sender: AnyObject) {
        if(self.validationPass()) {
            self.passWordParam["newpassword"] = self.passTxf.text
            self.passWordParam["repeatnewpassword"] = self.rePassTxf.text
//            KRProgressHUD.show()
            self.service.HTTPRequestPutMethodWithToken(token: self.appDelegate.token, param: self.passWordParam, functionPath: "/users/updatepassword", completionHandler:{(data,respone,error) in
                
                let httpStatus = respone as? HTTPURLResponse
                if(httpStatus?.statusCode != 200) {
                    KRProgressHUD.showMessage("loi \(String(describing: httpStatus?.statusCode))")
                }
                else {
//                    KRProgressHUD.show()
                    self.service.HTTPRequestPutMethodWithToken(token: self.appDelegate.token, param: self.profileParam, functionPath: "/users/profile", completionHandler: {(data,respone,error) in
//                        KRProgressHUD.dismiss()
                        if let httpStatus = respone as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                            KRProgressHUD.showMessage("lỗi \(httpStatus.statusCode)")
                        }
                        else {
                            // success ->update isprofileupdate in database
                            self.userData.UpdateUser(key: "isprofileupdated", value: "1")
                            DispatchQueue.main.async {
                                UserDefaults.standard.setValue(self.passTxf.text, forKey: "passphase")
                            }
                            UserDefaults.standard.set(true, forKey: "autoLogin")
//                            KRProgressHUD.dismiss()
                            self.dismiss(animated: true, completion: {
                                self.parentView.dismissLoginView()
                            })
                        }
                    })
                }
            })
        }
        
    }
    
    @IBAction func clearAllKeyboardAndPicker(sender: Any) {
        self.passTxf.resignFirstResponder()
        self.rePassTxf.resignFirstResponder()
    }
    @IBAction func showVoiceRegion(sender: Any) {
        self.clearKeyboard()
        self.pickerth = 1
        self.customPickerView.typeOfPicker = "region"
        self.customPickerView.initDataSource(data: self.region)
        self.customPickerView.view.frame = self.view.frame
        self.view.addSubview(self.customPickerView.view)
        self.customPickerView.pickerView.reloadAllComponents()
    }
    @IBAction func showDOB(sender : Any) {
        self.clearKeyboard()
        self.pickerth = 2
        self.customPickerView.typeOfPicker = "DOB"
        self.customPickerView.initDataSource(data: self.dob as NSArray)
        self.customPickerView.view.frame = self.view.frame
        self.view.addSubview(self.customPickerView.view)
        self.customPickerView.pickerView.reloadAllComponents()
    }
    @IBAction func radioClickAction(sender : UIButton) {
        if(sender == self.maleBnt) {
            if(self.gender == 3 || self.gender == 0) {
                self.gender = 1
                self.profileParam["gender"] = 1
                self.maleBnt.setBackgroundImage(UIImage.init(named: "Check box.png"), for: UIControlState.normal)
                self.feMaleBnt.setBackgroundImage(UIImage.init(named: "Uncheck box.png"), for: UIControlState.normal)
            }
        }
        else if(sender == self.feMaleBnt) {
            if(self.gender == 1 || self.gender == 0) {
                self.gender = 3
                self.profileParam["gender"] = 3
                self.maleBnt.setBackgroundImage(UIImage.init(named: "Uncheck box.png"), for: UIControlState.normal)
                self.feMaleBnt.setBackgroundImage(UIImage.init(named: "Check box.png"), for: UIControlState.normal)
            }
        }
    }
}
