//
//  ViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/12/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,MainScreenCellProtocol {
    var dict : [String : AnyObject]!
    var gameList: [Records] = []
    @IBOutlet var myCollectionGames: UICollectionView!
    @IBOutlet var rewardButton: UIButton!
    @IBOutlet var sendSMSButton: UIButton!
    let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
    let loginView: LoginViewController = LoginViewController()
    var currentUserEmail:String!
    @IBOutlet var FBButton: UIButton!
    let dataconnector:UsersData = UsersData()
    let recordconnector: RecordConnector = RecordConnector()
    let services: Services = Services()
    let mainScreenGameDetail: GameViewController = GameViewController()
    let helpScrennDetail: HelpViewController = HelpViewController()
    let rewarStore: RewardStoreViewController = RewardStoreViewController()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gameList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainSceenCollectionViewCell
        cell.setRadiusWithShadow(9)
        cell.delegate = self
        cell.game = self.gameList[indexPath.row]
        cell.Gamelabel.text = cell.game.title
        cell.totalScore.text = "Lượt tham gia: " + cell.game.value!
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.appstate == .online) {
            self.initData()
        }
    }
    func gotoLoginView() {
        self.loginView.mainView = self
        self.present(self.loginView, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
//     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//
//    }
//    func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//
//    }
    func GotoGameScreenDetail() {
        self.navigationController?.pushViewController(mainScreenGameDetail, animated: true)
    }
    func GotoHelpcreenDetail(game: Records) {
        helpScrennDetail.game = game
        self.navigationController?.pushViewController(helpScrennDetail, animated: true)
    }
    
    func initData() {
        let mockToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJlbWFpbCIsInN1YiI6eyJpZCI6IjEiLCJzY3JlZW5uYW1lIjoiQWRtaW5pc3RyYXRvciIsImZ1bGxuYW1lIjoiQWRtaW5pc3RyYXRvciIsImVtYWlsIjoiYWRtaW5AbG9jYWxob3N0LmxvY2FsIiwiYWRkcmVzcyI6IiIsInBhc3N3b3JkIjoiIiwiZ3JvdXBpZCI6ImFkbWluaXN0cmF0b3IiLCJhdmF0YXIiOiIiLCJnZW5kZXIiOiJtYWxlIiwic3RhdHVzIjoiMSIsImRvYiI6bnVsbCwib2F1dGh1aWQiOiIiLCJvYXV0aGFjY2Vzc3Rva2VuIjoiIiwib2F1dGhwcm92aWRlciI6IiIsIm9uZXNpZ25hbGlkIjoiIiwic3RhdGUiOiIwIiwiZGF0ZWNyZWF0ZWQiOiIxNDk0NTYwNjk2IiwiZGF0ZWxhc3RjaGFuZ2VwYXNzd29yZCI6IjAiLCJkYXRlbW9kaWZpZWQiOiIxNTExNzc5ODcwIiwibW9iaWxlbnVtYmVyIjoiIiwiaXN2ZXJpZmllZCI6IjEiLCJ2ZXJpZnl0eXBlIjoiMSJ9LCJpYXQiOjE1MTE4NTUzMjcsImV4cCI6MTU0Nzg1NTMyN30.vz80gczJSUE8D1p4imK2P_eU3lZRnpRKho5f9RMqWTc"
        let user: Users = self.dataconnector.fetchUserData(emai: self.currentUserEmail!) //get email form login view.
        if user != nil {
            self.services.HTTPRequestGetMethod(token:"Bearer " + mockToken, param: ["":""], functionPath: "/games/", complettionHandler: { (data, response,error) in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    self.recordconnector.AddRecord(record: json["records"] as! NSArray , user: user)
                    self.recordconnector.fectchRecords(){ (result) in
                        self.gameList = result
                        DispatchQueue.main.async {
                            self.myCollectionGames.reloadData()
                        }
                }
                }catch {
                    print(error)
                }
            })
        }
    }
    func initUI() {
        self.rewardButton.setRadiusWithShadow(self.rewardButton.frame.size.width/2)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        var width = UIScreen.main.bounds.width
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        width = width - 20
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        myCollectionGames!.collectionViewLayout = layout
    }
    @IBAction func FBlogin(sender : AnyObject) {
        if FBSDKAccessToken.current() != nil {
            FBSDKLoginManager().logOut()
            return
        }
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
//                        self.fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            print("check login status \(FBSDKAccessToken.current().tokenString)")
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                    print(result!)
//                    print(self.dict)
                }
            })
        }
    }
    
    @IBAction func gotoRewardStore(_ sender: UIButton) {
        self.navigationController?.pushViewController(rewarStore, animated: true)
    }
}

