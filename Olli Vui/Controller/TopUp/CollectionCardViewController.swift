//
//  CollectionCardViewController.swift
//  Olli Vui
//
//  Created by MK on 5/10/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD
import Firebase

class CollectionCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    @IBOutlet var backBnt : UIButton!
    @IBOutlet var middleTitleView : UIView!
    @IBOutlet var totalScoreLB : UILabel!
    @IBOutlet var cardCollection : UICollectionView!
    @IBOutlet var navigationNameLB : UILabel!
    
    var giffStore: GiffStore = GiffStore()
    var navigationName : String = ""
    var giffCards : [GifCardMD] = []
    let service :  Services = Services()
    let cardInfo : CardInfomationViewController = CardInfomationViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.giffCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardcell", for: indexPath) as! CardCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1).cgColor//UIColor.init(red: 118/255, green: 147/255, blue: 211/255, alpha: 1).cgColor
        cell.layer.cornerRadius = 10
        if(self.giffCards.count > 0) {
            cell.giffcard = self.giffCards[indexPath.row]
        }
        DispatchQueue.main.async {
            cell.setUpUI()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.giffCards[indexPath.row]
//        let arrayCharacters = item.name.components(separatedBy: " ")
        let message = "Đổi " + item.required + " điểm" + " lấy 01 " + item.name
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let msgFont = [NSAttributedStringKey.font: UIFont(name: "Arial", size: 17.0)!]
        let msgAttrString = NSMutableAttributedString(string: message, attributes: msgFont)
        alert.setValue(msgAttrString, forKey: "attributedMessage")
        
        
        alert.addAction(UIAlertAction(title: "Đổi", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.claimCard(indexPath: indexPath)
                break
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                break
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width
        if(width == 320) {
            return CGSize(width: 136, height: 136)
        }
        else if(width == 375) {
            return CGSize(width: 161, height: 161)
        }
        else if(width == 414) {
            return CGSize(width: 181, height: 181)
        }
        return CGSize(width: 181, height: 181)
    }
    
    func claimCard(indexPath: IndexPath) {
        KRProgressHUD.show()
        self.service.HTTPRequestPostMethodWithToken(token:"Bearer " + self.appDelegate.token, param: ["name" : self.giffCards[indexPath.row].name, "requiredpoint" : self.giffCards[indexPath.row].required], functionPath: "/stores/claim", completionHandler: { (data, response,error) in
            KRProgressHUD.dismiss()
            do {
                if(data != nil) {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    //TOTO show alertView with card's information
//                    KRProgressHUD.set(deadlineTime: 1.5)
//                    KRProgressHUD.showSuccess()
                    if(json["errors"] != nil) {
                        sleep(1)
                         KRProgressHUD.set(deadlineTime: 1)
                        let number: Int64 = (json["errors"] as! NSDictionary)["status"] as! Int64
                        if(number == 500) {
                             KRProgressHUD.showMessage("Không đủ điểm")
                        }else {
                             KRProgressHUD.showMessage((json["errors"] as! NSDictionary)["message"] as! String)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.cardInfo.cardInfo = json
                            self.present(self.cardInfo, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    print(response!)
                }
            }catch {
                KRProgressHUD.set(deadlineTime: 2)
                KRProgressHUD.showMessage((error.localizedDescription))
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       cardCollection.register(UINib.init(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cardcell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetGiffCard()
        self.getStoreMobileCard()
         self.setUpUI()
        self.getSynTotalScore()
    }
    
    func setUpUI() {
        self.navigationNameLB.text = self.navigationName
//        self.middleTitleView.layer.cornerRadius = 6
//        self.middleTitleView.layer.borderWidth = 1.5
//        self.middleTitleView.layer.borderColor = UIColor.init(red: 254/255, green: 194/255, blue: 45/255, alpha: 1).cgColor
    }
    
    @IBAction func backAction(sender: Any) {
        self.dismiss(animated: true , completion: nil)
    }
    
    func resetGiffCard () {
        self.giffCards.removeAll()
    }
    func getSynTotalScore(){
        if(self.appDelegate.user.oauthuid != nil) {
            let userID = self.appDelegate.user.oauthuid //Auth.auth().currentUser?.uid
            if(userID != nil) {
                let userRef = Database.database().reference().child("users").child(userID!)
                
                userRef.observe(.value, with: {(snapshot) in
                    let scoreValue = snapshot.value as? [String : AnyObject] ?? [:]
                    DispatchQueue.main.async {
                        self.totalScoreLB.text =  String(format: "%@", scoreValue["point"] as! CVarArg)
                    }
                }) {
                    (error) in
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func getStoreMobileCard () {
        let  id = self.giffStore.id
        self.service.HTTPRequestGetMethod(token: "Bearer " + self.appDelegate.token, param: ["":""], functionPath: "/stores/" + id, complettionHandler: {(data, respone, error) in
            do {
                if(data != nil) {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    self.parseJsonToGiffCard(json: json["data"] as! NSArray)
                }
                else {
                    //show error
                }
            }catch {
                print(error)
            }
        })
    }
    
    func parseJsonToGiffCard(json : NSArray) {
        json.map {
            let item : GifCardMD = GifCardMD.init(
                productName: ($0 as! Dictionary<String, Any>)["name"] as! String,
                quantity: ($0 as! Dictionary<String, Any>)["quantity"] as! String,
                required: ($0 as! Dictionary<String, Any>)["required"] as! String,
                cover : NSURL.init(string: ($0 as! Dictionary<String, Any>)["cover"] as! String)!
            )
            self.giffCards.append(item)
        }
        DispatchQueue.main.async {
            self.cardCollection.reloadData()
        }
    }

}
