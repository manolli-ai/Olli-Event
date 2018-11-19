//
//  HelpFirstViewController.swift
//  Olli Vui
//
//  Created by ManHuynh on 9/26/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class HelpFirstViewController: UIViewController {
    
    var mainViewController : ViewController!
    @IBOutlet var continueBnt : UIButton!
    @IBOutlet var webView : UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setUpUI()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setUpUI()  {
        self.continueBnt.layer.cornerRadius = 20
         do {
            let indexPath = Bundle.main.path(forResource: "index", ofType: "html")
            let content = try String(contentsOfFile: indexPath!, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: indexPath!)
            webView.loadHTMLString(content, baseURL: baseUrl)
         }catch {
            
        }
       
    }

    @IBAction func Continue(sender : Any) {
        UserDefaults.standard.setValue(true, forKey: "FirstLogin")
        self.dismiss(animated: true, completion: nil)
    }
}
