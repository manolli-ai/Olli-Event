//
//  TopUpCardViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/13/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

let topUPIdentifierCell = "TopUPIdentifierCell"
class TopUpCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var giffStore: GiffStore = GiffStore()
    var giffCards : [GifCardMD] = []
    let service :  Services = Services()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.giffCards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TopUpCardTableViewCell = tableView.dequeueReusableCell(withIdentifier: topUPIdentifierCell) as! TopUpCardTableViewCell
        cell.giffcard = self.giffCards[indexPath.row]
        cell.setUpUI()
        return cell
    }
    
    @IBOutlet var topUpCardTblView : UITableView!
    @IBOutlet var backBnt : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.topUpCardTblView.register(UINib.init(nibName: "TopUpCardTableViewCell", bundle: nil), forCellReuseIdentifier: topUPIdentifierCell)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetGiffCard()
        self.getStoreMobileCard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backAction (sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func resetGiffCard () {
        self.giffCards.removeAll()
    }

    func getStoreMobileCard () {
        let  id = self.giffStore.id
        self.service.HTTPRequestGetMethod(token: "Bearer " + self.appDelegate.token, param: ["":""], functionPath: "/stores/23" + id, complettionHandler: {(data, respone, error) in
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
                cover : ($0 as! Dictionary<String, Any>)["cover"] as! NSURL
            )
            self.giffCards.append(item)
        }
        DispatchQueue.main.async {
            self.topUpCardTblView.reloadData()
        }
    }
}
