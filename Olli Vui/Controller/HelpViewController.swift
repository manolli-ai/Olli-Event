//
//  HelpViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/12/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Crashlytics

class HelpViewController: UIViewController {

    @IBOutlet var crashBnt : UIButton!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var rewardButton: UIButton!
    @IBOutlet var totalScore: UILabel!
    @IBOutlet var helpView: UIView!
    @IBOutlet var headerView : UIView!
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var viewScroll : UIView!
    @IBOutlet var textView : UIView!
    let mainScreenGameDetail: GameViewController = GameViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let service:Services = Services()
    var game: Records!
    var mainViewController : ViewController!
//    let rewarStore: RewardStoreViewController = RewardStoreViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpData()
        self.setupUI()
        // Do any additional setup after loading the view.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.readData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.view.frame.width)
        print(self.view.frame.height)
        self.initContentForScrollView()
    }
    func readData() {
        let userID = Auth.auth().currentUser?.uid
        if(userID != nil) {
            let userRef = Database.database().reference().child("users").child(userID!)
            userRef.observeSingleEvent(of: .value, with: {(snapshot) in
                let scoreValue = snapshot.value as? [String : AnyObject] ?? [:]
                DispatchQueue.main.async {
//                    self.totalScore.text =  String(format: "%@", scoreValue["record_times"] as! CVarArg)
                }
            }) {
                (error) in
                print(error.localizedDescription)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.startButton.setRadiusWithShadow(20)
//        self.helpView.setRadiusWithShadow(5)
    }
    func initContentForScrollView() {
        let image1 : UIImageView = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: self.scrollView.frame.width - 20, height: (self.scrollView.frame.width - 20) * 1.2))
        image1.image = UIImage.init(named: "Instruction 1")
//        image1.contentMode = UIViewContentMode.scaleAspectFit
        let y2 = image1.frame.origin.y + image1.frame.height + 5
        let image2 : UIImageView = UIImageView.init(frame: CGRect.init(x: 10, y: y2, width: self.scrollView.frame.width - 20, height: (self.scrollView.frame.width - 20) * 1.2))
        image2.image = UIImage.init(named: "Instruction 2")
//        image2.contentMode = UIViewContentMode.scaleAspectFit
        let heightcontent = image2.frame.origin.y + image2.frame.height + 5
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: heightcontent)
        self.scrollView.addSubview(image1)
        self.scrollView.addSubview(image2)
    }
    func setUpData() {
        
    }
  
    
    func getRecordScrip() {
        self.service.HTTPRequestGetMethod(token:"Bearer " + self.appDelegate.token, param: ["":""], functionPath: "/records/scripts", complettionHandler: { (data, response,error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
            }catch {
                print(error)
            }
        })
    }

    @IBAction func Start(sender: AnyObject) {
        self.mainScreenGameDetail.game = self.game
        self.mainScreenGameDetail.mainViewController = self.mainViewController
//        self.navigationController?.pushViewController(self.mainScreenGameDetail, animated: true)
        self.present(self.mainScreenGameDetail, animated: true, completion: nil)
    }
    
    @IBAction func GotoStore(sender : AnyObject) {
//         self.present(self.rewarStore, animated: true, completion: nil)
//         self.navigationController?.pushViewController(rewarStore, animated: true)
    }
    @IBAction func crashAction(sender: Any) {
        Crashlytics.sharedInstance().crash()
    }
    @IBAction func backAction(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
