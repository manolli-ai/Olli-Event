//
//  FinishRecordGameViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 5/17/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class FinishRecordGameViewController: UIViewController {

    @IBOutlet var backBnt : UIButton!
    @IBOutlet var headerView : UIView!
    let customHeaderView : CustomHeaderViewViewController = CustomHeaderViewViewController()
    var mainViewController : ViewController!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.customHeaderView.currentView = self
        self.customHeaderView.parentView = self
        self.customHeaderView.lestMenu.mainViewController = self.mainViewController
        self.customHeaderView.mainViewController = self.mainViewController
        self.customHeaderView.mainViewController.currentIndexView = 7

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUpUI() {
        self.customHeaderView.view.frame = CGRect.init(x: 0, y: 0, width: self.headerView.frame.width, height: self.headerView.frame.size.height)
        self.customHeaderView.viewTitle = "Hoàn thành"
        self.headerView.addSubview(customHeaderView.view)
        self.backBnt.layer.cornerRadius = 20
    }
    
    @IBAction func backAction(sender : Any) {
        var controller = presentingViewController
        while let presentingVC = controller?.presentingViewController {
            controller = presentingVC
        }
        controller?.dismiss(animated: true)
//        UserDefaults.standard.set(false, forKey: "autoLogin")
//        self.mainViewController.gotoLoginViewWithPhoneNumberFromCurrentView(currentView: self)
//        let logginView : LoginWithPhoneNumberViewController = LoginWithPhoneNumberViewController()
//        self.present(logginView, animated: true, completion: nil)
    }
}
