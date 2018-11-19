//
//  PolicyViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 5/18/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class PolicyViewController: UIViewController, UITextViewDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mainViewController : ViewController!
//    let customHeaderView : CustomHeaderViewViewController! = CustomHeaderViewViewController()
    @IBOutlet var headerView : UIView!
    @IBOutlet var textView : UITextView!
    @IBOutlet var backBnt : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.customHeaderView.mainViewController.currentIndexView = 6
        
    }

    override func viewDidLayoutSubviews() {
        textView.setContentOffset(.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
//        self.customHeaderView.view.frame  = CGRect.init(x: 0, y: 0, width: self.headerView.frame.width, height: self.headerView.frame.height)
//        self.customHeaderView.viewTitle = "Điều khoản và điều kiện"
//        self.headerView.addSubview(self.customHeaderView.view)
    }
    func setUpData() {
//        self.customHeaderView.mainViewController = self.mainViewController
//        self.customHeaderView.currentView = self
//        self.customHeaderView.parentView = self
//        self.customHeaderView.lestMenu.mainViewController = self.mainViewController
    }
    
    @IBAction func BackAction(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
