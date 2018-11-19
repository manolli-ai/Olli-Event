//
//  CustomHeaderViewViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/17/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import Firebase

class CustomHeaderViewViewController: UIViewController {
    var parentView : UIViewController!
    @IBOutlet var menuBnt: UIButton!
    @IBOutlet var totalScore : UILabel!
    @IBOutlet var titleLB : UILabel!
    @IBOutlet var totalScoreView: UIView!
    
    var viewTitle: String = ""
    var mainViewController : ViewController!
    let lestMenu  = CustomLeftMenuViewController()
    var currentView : UIViewController!
    let utility : Utility = Utility()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
        self.setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLB.text = self.viewTitle
//        self.getSynTotalScore()
        self.lestMenu.view.frame = CGRect.init(x: -self.parentView.view.frame.width, y: self.parentView.view.frame.origin.y, width: self.parentView.view.frame.width, height: self.parentView.view.frame.height)//self.parentView.view.frame
         self.parentView.view.addSubview(self.lestMenu.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUpUI() {
//        self.menuBnt.setBackgroundImage(self.defaultMenuImage(), for: UIControlState.normal)
//        self.totalScoreView.layer.cornerRadius = 20
//        self.totalScoreView.layer.borderWidth = 1.5
//        self.totalScoreView.layer.borderColor = UIColor.init(red: 254/255, green: 194/255, blue: 45/255, alpha: 1).cgColor
    }
    func setUpData() {
        self.lestMenu.mainViewController = self.mainViewController
    }
    
    @IBAction func openMenu() {
        if(self.parentView != nil) {
            
            self.lestMenu.currentViewController = self.currentView
            UIView.transition(with: self.parentView.view, duration: 0.4, options: .curveLinear, animations: {
                self.lestMenu.view.frame = self.parentView.view.frame
                self.lestMenu.updateAll()
            }, completion: nil)
        }
    }
    
    func getSynTotalScore(){
        if(self.appDelegate.user.oauthuid != nil) {
            let userID = self.appDelegate.user.oauthuid //Auth.auth().currentUser?.uid
            if(userID != nil) {
                let userRef = Database.database().reference().child("users").child(userID!)
                userRef.observe(.value, with: {(snapshot) in
                    let scoreValue = snapshot.value as? [String : AnyObject] ?? [:]
                    DispatchQueue.main.async {
                        self.totalScore.text =  String(format: "%@", scoreValue["point"] as! CVarArg)
//                        self.totalScore.text =  String(format: "%@", scoreValue["tmp_point"] as! CVarArg)
                        NSLog(self.totalScore.text!)
                    }
                }) {
                    (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 15, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 25, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 15, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }

}
