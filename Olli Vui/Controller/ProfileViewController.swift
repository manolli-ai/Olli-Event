//
//  ProfileViewController.swift
//  Olli Vui
//
//  Created by MK on 5/7/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProfileViewController: UIViewController, UITextFieldDelegate,CustomPickerProtocol {
    func updateDefaultValuew(title: String) {
        DispatchQueue.main.async {
            self.regionLB.text = title
        }
    }
    
    func setTitleForItem(id:Int ,title: String) {
        if(self.pickerth == 1) {
            self.regionLB.text = title
            self.profileParam["voiceregion"] = id
        }
        else if(self.pickerth == 2) {
            self.dobLB.text = title
            self.profileParam["dob"] = "01/01/\(title)"
        }
    }
    
    @IBOutlet var emailTf : UITextField!
    @IBOutlet var nameTf : UITextField!
    @IBOutlet var oldPassTf : UITextField!
    @IBOutlet var newPassTF : UITextField!
    @IBOutlet var reNewPassTF : UITextField!
    
    @IBOutlet var maleBnt : UIButton!
    @IBOutlet var feMaleBnt : UIButton!
    @IBOutlet var voiceregionBnt : UIButton!
    @IBOutlet var dobBnt : UIButton!
    @IBOutlet var backBnt : UIButton!
    @IBOutlet var updateBnt : UIButton!
    
    @IBOutlet var regionLB : UILabel!
    @IBOutlet var dobLB : UILabel!
   
    
    @IBOutlet var oldPassView : UIView!
    @IBOutlet var newPassView : UIView!
    @IBOutlet var reNewPassView : UIView!
    @IBOutlet var nameView : UIView!
    @IBOutlet var emailView : UIView!
    @IBOutlet var changePassView : UIView!
    
    @IBOutlet var scrollView : UIScrollView!
    
    let serviceConstant : ServicesConstant = ServicesConstant()
    let customPickerView : CustomPickerViewController = CustomPickerViewController()
    var mainViewController :  ViewController!
    var service : Services = Services()
    let userData : UsersData = UsersData()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isKeyBoardShowing = false
    var isFocusAtChangePassView = true
    var gender = 0
    var voiceregion = 1
    var profileParam : Dictionary<String, Any> = [:]
    var pickerth = 1
    var region : NSArray = [""]
    let dob = ["1947","1948","1949","1950","1951","1952","1953","1954","1955","1956","1957","1958","1959","1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006"]
    var pickerDataSource = [""]
    
    var passWordParam : Dictionary<String, Any> = [:]
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.nameTf) {
            if(self.nameTf.text != "") {
                self.profileParam["fullname"] = self.nameTf.text
//                self.emailTf.becomeFirstResponder()
                 textField.resignFirstResponder()
            }
        } else if(textField == self.emailTf) {
            if(self.emailTf.text != "") {
                self.profileParam["email"] = self.emailTf.text
                textField.resignFirstResponder()
            }
        }
        else if(textField == self.oldPassTf || textField == self.newPassTF || textField == self.reNewPassTF ) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == oldPassTf || textField == newPassTF || textField == reNewPassTF) {
            self.isFocusAtChangePassView = true
        }
        else {
            self.isFocusAtChangePassView = false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: 490)
        
        self.setUpData()
        self.setUpUI()
        self.region = self.serviceConstant.initDataForProvince()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let _ : Int = Int(keyboardSize.height)
            if(isKeyBoardShowing == false && isFocusAtChangePassView) {
                UIView.transition(with: self.view, duration: 0.4, options: .curveLinear, animations: {
                    self.view.frame.origin.y -= 216
                    
                },  completion: nil)
            }
        }
        self.isKeyBoardShowing = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let _ : Int = Int(keyboardSize.height)
            if(isKeyBoardShowing && isFocusAtChangePassView) {
                UIView.transition(with: self.view, duration: 0.4, options: .curveLinear, animations: {
                    self.view.frame.origin.y += 216
                    
                },  completion: nil)
            }
        }
        self.isKeyBoardShowing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainViewController.currentIndexView = 3
        self.loadDefaultValue()
        self.getProfileFromService()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(isKeyBoardShowing && isFocusAtChangePassView == false) {
            self.view.frame.origin.y += 216
            self.isKeyBoardShowing = false
        }
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
    
    }
    
    func loadDefaultValue() {
        self.emailTf.text = self.appDelegate.user.email
        self.nameTf.text = self.appDelegate.user.fullname
    }
    func setUpUI() {
        self.updateBnt.layer.cornerRadius = 20
        self.nameView.layer.cornerRadius = 20
        self.emailView.layer.cornerRadius = 20
        
        self.nameView.layer.borderWidth = 0.5
        self.emailView.layer.borderWidth = 0.5
        
        self.nameView.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        self.emailView.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor
        
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
        self.profileParam["email"] = ""
        self.profileParam["fullname"] = ""
        self.profileParam["gender"] = 0
        self.profileParam["dob"] = ""
        self.profileParam["voiceregion"] = 0
        self.customPickerView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func clearKeyboard() {
        self.emailTf.resignFirstResponder()
        self.nameTf.resignFirstResponder()
    }
    
    @IBAction func backAction(sender : Any) {
        self.dismiss(animated: true , completion: nil)
    }
    @IBAction func updateAction(sender : Any) {
        self.profileParam["email"] = self.emailTf.text
        self.profileParam["fullname"] = self.nameTf.text
         self.profileParam["dob"] = "01/01/\(self.dobLB.text!)"
        KRProgressHUD.show()
        self.service.HTTPRequestPutMethodWithToken(token: self.appDelegate.token, param: self.profileParam, functionPath: "/users/profile", completionHandler: {(data,respone,error) in
                KRProgressHUD.dismiss()
            if(error != nil) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    sleep(1)
                    KRProgressHUD.set(deadlineTime: 1.0)
                    KRProgressHUD.showMessage(((json["errors"] as! Dictionary<String, Any>)["message"] as! String))
                }
                catch {
                    
                }
                return
            }
            if let httpStatus = respone as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                        sleep(1)
//                        KRProgressHUD.set(deadlineTime: 1.0)
                
//                        KRProgressHUD.showMessage("lỗi , vui lòng kiểm tra lại thông tin")
//                        KRProgressHUD.showMessage("lỗi \(httpStatus.statusCode)")
                    }
                    else {
//                        TODO -- update to database
                        DispatchQueue.main.async {
                            self.appDelegate.user.email = self.emailTf.text
                            self.appDelegate.user.fullname = self.nameTf.text
                            self.appDelegate.gender = self.profileParam["gender"] as! Int
                        }
                        //update Pass
                        DispatchQueue.main.async {
                            if(self.oldPassTf.text != "") {
                                self.updatePassword()
                            }else {
                                KRProgressHUD.dismiss()
                                self.dismiss(animated: true, completion: {
                                })
                            }
                        }
                    }
                })
    }
    
    func getProfileFromService() {
        KRProgressHUD.show()
        self.service.HTTPRequestGetMethodWithOnlyToken(token: self.appDelegate.token, functionPath: "/users/profile", completionHandler: {(data,respone,error) in
            KRProgressHUD.dismiss()
            if let httpStatus = respone as? HTTPURLResponse, httpStatus.statusCode != 200 {
                KRProgressHUD.showMessage("lỗi \(httpStatus.statusCode)")
                return
            }
            do{
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                let gender : Int = Int((((((((json["data"] as! NSDictionary)["profile"]) as! NSDictionary)["data"]) as! NSDictionary)["gender"]) as! NSDictionary)["value"] as! Int)
                let dob = Double(((((((json["data"] as! NSDictionary)["profile"]) as! NSDictionary)["data"]) as! NSDictionary)["dob"]) as! Double)
                let voiceregion = Int(((((((json["data"] as! NSDictionary)["profile"]) as! NSDictionary)["data"]) as! NSDictionary)["voiceregion"]) as! Int)
                self.profileParam["voiceregion"] = voiceregion
                
                DispatchQueue.main.async {
                    if(voiceregion > 0) {
                        self.regionLB.text = ((self.region[voiceregion] as! NSDictionary)["label"] as! String)
                        self.customPickerView.setIndexOfRegion(id: voiceregion)
                    }
                    if(dob > 0) {
                        self.dobLB.text = self.removeSpaceC(string: dob.getDateStringFromUTC())
                        self.customPickerView.setIndexOfDOB(id: self.indexOfItem(value: self.removeSpaceC(string: self.dobLB.text!)))
                    }
                    if(gender == 1) {
                        self.radioClickAction(sender: self.maleBnt)
                    }
                    else {
                        self.radioClickAction(sender: self.feMaleBnt)
                    }
                }
            }
            catch {
                
            }
        })
    }
    
    func removeSpaceC(string : String) ->String {
        let str = string.components(separatedBy: " ").last
        if((str) != nil) {
            return str!
        }
        else {
            return string
        }
    }
    func indexOfItem(value : String) -> Int {
        for i in (0...self.dob.count - 1) {
            if self.dob[i] == value {
                return i
            }
        }
        return 0
    }
    
    @IBAction func overloadAction(sender : Any) {
       self.nameTf.resignFirstResponder()
        self.emailTf.resignFirstResponder()
    }
    
    @IBAction func showVoiceRegion(sender: Any) {
        self.clearKeyboard()
        self.pickerth = 1
        self.customPickerView.typeOfPicker = "region"
        self.customPickerView.initDataSource(data: self.region as NSArray)
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
    func updatePassword() {
        if(self.validationEmptyTextF() == false) {
            KRProgressHUD.set(deadlineTime: 1)
            KRProgressHUD.showMessage("Mật khẩu không thể bỏ trống")
        }
        else {
            if(self.validationOldPassword() == false) {
                KRProgressHUD.set(deadlineTime: 1)
                KRProgressHUD.showMessage("Mậtkhẩu cũ không đúng")
            }
            else {
                if(self.validationNewPassword()) {
                    // call  update service
//                    KRProgressHUD.show()
                    self.passWordParam["newpassword"] = self.newPassTF.text
                    self.passWordParam["repeatnewpassword"] = self.reNewPassTF.text
                    self.service.HTTPRequestPutMethodWithToken(token: self.appDelegate.token, param: self.passWordParam, functionPath: "/users/updatepassword", completionHandler:{(data,respone,error) in
//                        KRProgressHUD.dismiss()
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
                    KRProgressHUD.set(deadlineTime: 1)
                    KRProgressHUD.showMessage("Mật khẩu mới không trủng khớp")
                }
            }
        }
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
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        let result = (dateFormatter.string(from: date)).components(separatedBy: ",").last
        return result!
    }
    func stringValue() -> String {
        return String(format: "%.0f", self)
    }
}
