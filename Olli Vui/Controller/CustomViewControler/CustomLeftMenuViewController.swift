//
//  CustomLeftMenuViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/24/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import Firebase

class CustomLeftMenuViewController: UIViewController {

    @IBOutlet var overlayBnt: UIButton!
    @IBOutlet var avatar : UIImageView!
    @IBOutlet var avataView : UIView!
    @IBOutlet var storeBnt : UIButton!
    @IBOutlet var homeBnt : UIButton!
    @IBOutlet var policyBnt : UIButton!
    @IBOutlet var updateInformationBnt : UIButton!
    //@IBOutlet var changePassBnt : UIButton!
    @IBOutlet var logOutBnt : UIButton!
    @IBOutlet var phoneNumberLB : UILabel!
    @IBOutlet var nameLB : UILabel!
    @IBOutlet var totalScoreLB : UILabel!
    @IBOutlet var tempScoreLB : UILabel!
    @IBOutlet var hiddenView : UIView!
    @IBOutlet var yellowStart : UIImageView!
    @IBOutlet var grayStart : UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentViewController : UIViewController!
    var mainViewController : ViewController!
    var currentIndexScreen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.hiddenView.isHidden =  false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.updateAll()
    }
    
    func updateAll() {
        self.resetUIState()
        self.updateBntState()
        self.getSynTotalScore()
        self.setUpData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetUIState() {
        self.homeBnt.isHighlighted = false
        self.homeBnt.isUserInteractionEnabled = true
        self.updateInformationBnt.isHighlighted = false
        self.updateInformationBnt.isUserInteractionEnabled = true
        //self.changePassBnt.isHighlighted = false
        //self.changePassBnt.isUserInteractionEnabled = true
        self.storeBnt.isHighlighted = false
        self.storeBnt.isUserInteractionEnabled = true
        self.policyBnt.isHighlighted = false
        self.policyBnt.isUserInteractionEnabled = true
    }
    
    func updateBntState() {
        switch self.mainViewController.currentIndexView {
        case 1:
            do {
                self.homeBnt.isHighlighted = true
                self.homeBnt.isUserInteractionEnabled = false
                break
            }
        case 2 :
            do {
                break
            }
        case 3 :
            do {
                break
            }
        case 4 :
            do {
                self.storeBnt.isHighlighted = true
                self.storeBnt.isUserInteractionEnabled = false
                break
            }
        case 6 :
            do {
                self.policyBnt.isHighlighted = true
                self.policyBnt.isUserInteractionEnabled = false
                break
            }
        default: break
            
        }
    }
    
    func setUpUI() {
        self.avataView.layer.cornerRadius = 35
        self.avatar.layer.cornerRadius = 22.5
        self.avatar.layer.masksToBounds = true
    }
    func setUpData() {
        self.phoneNumberLB.text = self.appDelegate.myPhoneNumber
        self.nameLB.text = self.appDelegate.user.fullname
//        print(self.appDelegate.user.gender as Any)
        DispatchQueue.main.async {
            if(self.appDelegate.gender == 1) {
                self.avatar.image = UIImage.init(named: "Avatar Male.png")
            }
            else { // ==3
                self.avatar.image = UIImage.init(named: "Avatar Female.png")
            }
        }
    }
    func getSynTotalScore() {
        if(self.appDelegate.user.oauthuid != nil) {
            let userID = self.appDelegate.user.oauthuid
            if(userID != nil){
                let userRef = Database.database().reference().child("users").child(userID!)
                
                userRef.observeSingleEvent(of: .value, with: {(snapshot) in
                    let scoreValue = snapshot.value as? [String : AnyObject] ?? [:]
                    DispatchQueue.main.async {
                        self.totalScoreLB.text =  String(format: "%@", scoreValue["point"] as! CVarArg)
                        self.tempScoreLB.text =  String(format: "%@", scoreValue["tmp_point"] as! CVarArg)
                    }
                }) {
                    (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func overlayAction(sender : Any) {
//        self.view.removeFromSuperview()
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.view.frame = CGRect.init(x: -self.view.frame.width, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }, completion: nil)
    }
    @IBAction func gotoHomeAction(sender: Any) {
        self.mainViewController.gotoHelpScreenFromCurrentView(currentView: self.currentViewController)
        self.view.removeFromSuperview()
    }
    @IBAction func gotoUpdateInformationAction(sender: Any) {
        self.mainViewController.gotoProfileViewFromCurrentView(currentView: self.currentViewController)
        self.view.removeFromSuperview()
    }
    @IBAction func gotoChangePassAction(sender: Any) {
        self.mainViewController.gotoChangePassViewFromCurrentView(currentView: self.currentViewController)
        self.view.removeFromSuperview()
    }
    @IBAction func gotoStoreAction(sender: Any) {
        self.mainViewController.gotoStoreFromCurrentView(currentView: self.currentViewController)
        self.view.removeFromSuperview()
    }
    @IBAction func gotoLogoutAction(sender : Any) {
        UserDefaults.standard.set(false, forKey: "autoLogin")
        self.mainViewController.gotoLoginViewWithPhoneNumberFromCurrentView(currentView: self.currentViewController)
        self.view.removeFromSuperview()
    }
    @IBAction func gotoPolicyAction(sender : Any) {
        self.mainViewController.gotoPolicyView(currentView: self.currentViewController)
        self.view.removeFromSuperview()
    }
    @IBAction func gotoHelpFirstView(sender : Any) {
        self.mainViewController.gotoHelpFirstFromCurrentView(currentView: self.currentViewController)
        self.view.removeFromSuperview()
    }
    @IBAction func gotoClaimHistory(sender : Any) {
        self.mainViewController.gotoClaimHistoryView(currentView: self.currentViewController)
    }
    
    @IBAction func gotoAboutView(sender : Any) {
        self.mainViewController.gotoAboutView(currentView: self.currentViewController)
    }
    
    
    func dismissAllView() {
        var controller = presentingViewController
        while let presentingVC = controller?.presentingViewController {
            controller = presentingVC
        }
        controller?.dismiss(animated: true)
    }
    
}
