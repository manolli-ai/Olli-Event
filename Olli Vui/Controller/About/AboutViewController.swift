//
//  AboutViewController.swift
//  Olli Vui
//
//  Created by ManHuynh on 10/9/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet var backBnt : UIButton!
    
    
    var mainViewController : ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetupUI() {
        self.backBnt.layer.cornerRadius = 20
    }
    
    @IBAction func BackAction(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
