//
//  RewardStoreViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/14/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit
import Firebase

class RewardStoreViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.giffStore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifStorecell", for: indexPath) as! GifStoreCollectionViewCell
        var image: UIImage = UIImage()
        var title: String = ""
        if(self.giffStore[indexPath.row].id == "23") {
            image = UIImage.init(named: "Icon_ma_the_di_dong")!
            title = "Mã thẻ di động"
        }else if(self.giffStore[indexPath.row].id == "24"){
            image =  UIImage.init(named: "Icon_qua_luu_niem")!
            title = "Quà lưu niệm"
        }
        else if(self.giffStore[indexPath.row].id == "25"){
            image =  UIImage.init(named: "Icon_tien_mat")!
            title = "tiền mặt"
        }else{
            image =  UIImage.init(named: "Icon_qua_luu_niem")!
            title = "Quà lưu niệm"
        }
        DispatchQueue.main.async {
            cell.image.image = image
            cell.title.text = self.giffStore[indexPath.row].name
            cell.updateLayOut()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let name: String = self.giffStore[indexPath.row].name {
            self.cardCollectionView.navigationName = name
        }
        if let id : String = self.giffStore[indexPath.row].id {
            self.cardCollectionView.giffStore.id = id
        }
       self.present(cardCollectionView, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width
        if(width == 320) {
            return CGSize(width: 136, height: 183)
        }
        else if(width == 375) {
            return CGSize(width: 161, height: 213)
        }
        else if(width == 414) {
            return CGSize(width: 181, height: 236)
        }
        return CGSize(width: 320, height: 568)
    }
    
    let identifiCell: String = "rewardCell"
    let cardCollectionView : CollectionCardViewController = CollectionCardViewController()
    var giffStore : [GiffStore] = []
    let service : Services = Services()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var mainViewController : ViewController!
    @IBOutlet var headerView : UIView!
    @IBOutlet var creditTableView: UITableView!
    @IBOutlet var creditLabel: UILabel!
    @IBOutlet var gifsCollection : UICollectionView!
    let customHeaderView : CustomHeaderViewViewController! = CustomHeaderViewViewController()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RewardStoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifiCell, for: indexPath) as! RewardStoreTableViewCell
        cell.selectionStyle = .none
        cell.title.text = self.giffStore[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            do {
                if(self.giffStore.count > 0) {
                    self.present(cardCollectionView, animated: true, completion: nil)
                }
        }
           break
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.gifsCollection!.register(UINib.init(nibName: "GifStoreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gifStorecell")
        self.setUpData()
        self.setUpUI()
        self.customHeaderView.parentView = self
    }

    func setUpUI() {
        self.customHeaderView.view.frame  = CGRect.init(x: 0, y: 0, width: self.headerView.frame.width, height: self.headerView.frame.height)
        self.customHeaderView.viewTitle = "Cửa hàng quà tặng"
        self.headerView.addSubview(self.customHeaderView.view)
    }
    func setUpData() {
        self.customHeaderView.mainViewController = self.mainViewController
        self.customHeaderView.currentView = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Get Data from services
        self.resetGiffStore()
        self.getStoreList()
//        self.getSynTotalScore()
        self.customHeaderView.mainViewController.currentIndexView = 4
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func getStoreList () {
        self.service.HTTPRequestGetMethod(token: "Bearer " + appDelegate.token, param: ["":""], functionPath: "/stores", complettionHandler: {(data, respone, error) in
            do {
                if(data != nil) {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    self.parseJsonToGiffStore(json: json["data"] as! NSArray)
                }
                else {
                    //show error
                }
            }catch {
                print(error)
            }
        })
    }
    func parseJsonToGiffStore(json : NSArray) {
        json.map {
            let item : GiffStore = GiffStore.init(
                id: ($0 as! Dictionary<String, Any>)["id"] as! String,
                name: ($0 as! Dictionary<String, Any>)["name"] as! String,
                datecreated: ($0 as! Dictionary<String, Any>)["datecreated"] as! String,
                humandatecreated: ($0 as! Dictionary<String, Any>)["humandatecreated"] as! String)
            self.giffStore.append(item)
        }
        DispatchQueue.main.async {
            self.gifsCollection.reloadData()
        }
    }
    func getSynTotalScore() {
        if(self.appDelegate.user.oauthuid != nil) {
            let userID = self.appDelegate.user.oauthuid //Auth.auth().currentUser?.uid
            if(userID != nil) {
                let userRef = Database.database().reference().child("users").child(userID!)
                userRef.observeSingleEvent(of: .value, with: {(snapshot) in
                    let scoreValue = snapshot.value as? [String : AnyObject] ?? [:]
                    DispatchQueue.main.async {
                        //                    self.creditLabel.text =  String(format: "Số điểm hiện có : %@", scoreValue["point"] as! CVarArg)
                    }
                }) {
                    (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    func resetGiffStore() {
        self.giffStore.removeAll()
    }
}
