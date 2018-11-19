//
//  ViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/12/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit
import AVFoundation
import Firebase
import KRProgressHUD

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MainScreenCellProtocol {
    func GotoHelpcreenDetail(game: Records , limit : Int) {
    
        let checkNumber : Int = (Int)(UserDefaults.standard.value(forKey: "PolicyLimit") as! String)!
        if(limit < checkNumber ) {
            self.GotoJobDetailScreen()
        }
        else {
            KRProgressHUD.showMessage("Bạn đã hết lượt chơi")
        }
    }
    
    var gameList: [Records] = []
    @IBOutlet var myCollectionGames: UICollectionView!
    @IBOutlet var rewardButton: UIButton!
    @IBOutlet var sendSMSButton: UIButton!
     @IBOutlet var headerView : UIView!
    //let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let customHeaderView : CustomHeaderViewViewController = CustomHeaderViewViewController()
    let loginView: LoginViewController = LoginViewController()
    let loginViewWithPhoneNumber : LoginWithPhoneNumberViewController = LoginWithPhoneNumberViewController()
    var currentUserEmail:String!
    @IBOutlet var FBButton: UIButton!
    let dataconnector:UsersData = UsersData()
    let recordconnector: RecordConnector = RecordConnector()
    let services: Services = Services()
    let mainScreenGameDetail: GameViewController = GameViewController()
    let helpScrennDetail: HelpViewController = HelpViewController()
    let rewarStore: RewardStoreViewController = RewardStoreViewController()
    let leftMenuView : CustomLeftMenuViewController = CustomLeftMenuViewController()
    let changePassView : ChangePasswordViewController = ChangePasswordViewController()
    let updateInformationView : ProfileViewController = ProfileViewController()
    let policyView : PolicyViewController = PolicyViewController()
    let helpFirstView : HelpFirstViewController = HelpFirstViewController()
    let jobDetailView : JobDetailViewController = JobDetailViewController()
    let claimHistoryView : ClaimHistoryViewController = ClaimHistoryViewController()
    let aboutView : AboutViewController = AboutViewController()
    
    var currentIndexView : Int = 0
    
    var job:Jobs = Jobs()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.gameList.count
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainSceenCollectionViewCell
        cell.setRadiusWithShadow(9)
        cell.delegate = self
        cell.job = self.job
        cell.updateUI()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         self.GotoHelpcreenDetail()
//        self.GotoJobDetailScreen()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem
        // Do any additional setup after loading the view, typically from a nib.
        myCollectionGames.register(UINib.init(nibName: "MainSceenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // Asking user permission for accessing Microphone
        AVAudioSession.sharedInstance().requestRecordPermission () {
            [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
            } else {
                // User denied microphone. Tell them off!
                
            }
        }
        self.initUI()
        self.gotoLoginView()
//        self.dataconnector.DeleteAllRecords(tblName: "Users")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if(appDelegate.appstate == .online) {
                //show first help view
                if(UserDefaults.standard.value(forKey: "FirstLogin") == nil) {
                    gotoHelpFirstView()
                } else {
//                    self.initData()
                     UserDefaults.standard.setValue(false, forKey: "FirstLogin")
                }
            self.getSynTotalScore()
        }
        self.customHeaderView.mainViewController.currentIndexView = 1
    }
    func gotoHelpFirstView() {
        self.present(self.helpFirstView, animated: true, completion: nil)
    }
    func gotoLoginView() {
////        self.loginView.mainView = self
////        self.present(self.loginView, animated: true, completion: nil)
        self.loginViewWithPhoneNumber.mainViewController = self
        self.present(self.loginViewWithPhoneNumber, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
//     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }
//    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
    func GotoGameScreenDetail() {
//        self.navigationController?.pushViewController(mainScreenGameDetail, animated: true)
    }
    func GotoHelpcreenDetail() {
        self.helpScrennDetail.mainViewController = self
        self.present(helpScrennDetail, animated: true, completion: nil)
    }
    func GotoJobDetailScreen() {
        self.jobDetailView.mainViewController = self
        self.present(jobDetailView, animated: true, completion: nil)
    }
    
    func initData() {
//        let mockToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJlbWFpbCIsInN1YiI6eyJpZCI6IjEiLCJzY3JlZW5uYW1lIjoiQWRtaW5pc3RyYXRvciIsImZ1bGxuYW1lIjoiQWRtaW5pc3RyYXRvciIsImVtYWlsIjoiYWRtaW5AbG9jYWxob3N0LmxvY2FsIiwiYWRkcmVzcyI6IiIsInBhc3N3b3JkIjoiIiwiZ3JvdXBpZCI6ImFkbWluaXN0cmF0b3IiLCJhdmF0YXIiOiIiLCJnZW5kZXIiOiJtYWxlIiwic3RhdHVzIjoiMSIsImRvYiI6bnVsbCwib2F1dGh1aWQiOiIiLCJvYXV0aGFjY2Vzc3Rva2VuIjoiIiwib2F1dGhwcm92aWRlciI6IiIsIm9uZXNpZ25hbGlkIjoiIiwic3RhdGUiOiIwIiwiZGF0ZWNyZWF0ZWQiOiIxNDk0NTYwNjk2IiwiZGF0ZWxhc3RjaGFuZ2VwYXNzd29yZCI6IjAiLCJkYXRlbW9kaWZpZWQiOiIxNTExNzc5ODcwIiwibW9iaWxlbnVtYmVyIjoiIiwiaXN2ZXJpZmllZCI6IjEiLCJ2ZXJpZnl0eXBlIjoiMSJ9LCJpYXQiOjE1MTE4NTUzMjcsImV4cCI6MTU0Nzg1NTMyN30.vz80gczJSUE8D1p4imK2P_eU3lZRnpRKho5f9RMqWTc"
//        let user: Users = Users()//self.dataconnector.fetchUserData(emai: self.currentUserEmail!) //get email form login view.
//        if (user != nil)
//        {
            self.services.HTTPRequestGetMethod(token:"Bearer " + self.appDelegate.token, param: ["":""], functionPath: "/games/", complettionHandler: { (data, response,error) in
                do {
                    if(data != nil) {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        self.recordconnector.AddRecord(record: json["records"] as! NSArray )//, user: user)
                        self.recordconnector.fectchRecords(){ (result) in
                            self.gameList = result
                            DispatchQueue.main.async {
                                self.myCollectionGames.reloadData()
                            }
                    }
                }
                }catch {
                    print(error)
                }
            })
//        }
    }
    func initUI() {
        self.customHeaderView.mainViewController = self
        self.customHeaderView.currentView = self
        self.customHeaderView.parentView = self
        
//        self.customHeaderView.view.frame = CGRect.init(x: 0, y: 0, width: self.headerView.frame.width, height: self.headerView.frame.size.height)
        self.customHeaderView.viewTitle = "Danh sách công việc"
        self.headerView.addSubview(customHeaderView.view)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        width = width - 32
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        myCollectionGames!.collectionViewLayout = layout
    }
    
    
    func getSynTotalScore() {
        if(self.appDelegate.user.oauthuid != nil) {
            let userID = self.appDelegate.user.oauthuid //Auth.auth().currentUser?.uid
            if(userID != nil) {
                let userRef = Database.database().reference().child("users").child(userID!)
                userRef.observeSingleEvent(of: .value, with: {(snapshot) in
                    let scoreValue = snapshot.value as? [String : AnyObject] ?? [:]
                    let totalScore = String(format: "%@", scoreValue["point"] as! CVarArg)
                    let totalAnswer = scoreValue["record_times"] as! Int // String(format: "%@", scoreValue["record_times"] as! CVarArg)
                    let job = Jobs.init(title: "", point: totalScore , time: totalAnswer , total: "")
                    self.job = job
                    DispatchQueue.main.async {
                        self.myCollectionGames.reloadData()
                    }
                }) {
                    (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func gotoRewardStore(_ sender: UIButton) {
//        self.navigationController?.pushViewController(rewarStore, animated: true)
    }
    
    func gotoHelpScreenFromCurrentView(currentView : UIViewController) {
        currentView.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    func gotoStoreFromCurrentView(currentView : UIViewController)  {
        self.rewarStore.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.rewarStore, animated: true, completion: nil)
        }
        else {
            currentView.present(self.rewarStore, animated: true, completion: nil)
        }
    }
    func gotoChangePassViewFromCurrentView(currentView : UIViewController) {
        self.changePassView.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.changePassView, animated: true, completion: nil)
        }
        else {
            currentView.present(self.changePassView, animated: true, completion: {
                
            })
        }
    }
    func gotoProfileViewFromCurrentView(currentView : UIViewController) {
        self.updateInformationView.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.updateInformationView, animated: true, completion: nil)
        }
        else {
            currentView.present(self.updateInformationView, animated: true, completion: {
                
            })
        }
    }
    func gotoLoginViewWithPhoneNumberFromCurrentView(currentView: UIViewController) {
        self.loginViewWithPhoneNumber.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.loginViewWithPhoneNumber, animated: true, completion: nil)
        }
        else {
            currentView.present(self.loginViewWithPhoneNumber, animated: true, completion: {
                
            })
        }
    }
    func gotoHelpFirstFromCurrentView(currentView: UIViewController) {
        self.helpFirstView.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.helpFirstView, animated: true, completion: nil)
        }
        else {
            currentView.present(self.helpFirstView, animated: true, completion: {
                
            })
        }
    }
    func gotoPolicyView(currentView : UIViewController) {
        self.policyView.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.policyView, animated: true, completion: nil)
        }
        else {
            currentView.present(self.policyView, animated: true, completion: {
                
            })
        }
    }
    func gotoClaimHistoryView(currentView : UIViewController) {
        self.claimHistoryView.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.claimHistoryView, animated: true, completion: nil)
        }
        else {
            currentView.present(self.claimHistoryView, animated: true, completion: {
                
            })
        }
    }
    func gotoAboutView(currentView : UIViewController) {
        self.aboutView.mainViewController = self
        if(self.currentIndexView == 1) {
            self.present(self.aboutView, animated: true, completion: nil)
        }
        else {
            currentView.present(self.aboutView, animated: true, completion: {
                
            })
        }
    }

}

