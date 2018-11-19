//
//  ClaimHistoryViewController.swift
//  Olli Vui
//
//  Created by ManHuynh on 10/1/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD

class ClaimHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ClaimHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: indentifierString, for: indexPath) as! ClaimHistoryTableViewCell
        cell.titleStr = self.dataSource[indexPath.row].title
        cell.timeStr = self.dataSource[indexPath.row].time.components(separatedBy: ",")[0]
        cell.updateUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cardInfo.cardInfo = self.carInfoArray[indexPath.row]
        self.present(self.cardInfo, animated: true, completion: nil)
    }
    
    @IBOutlet var historyTbV : UITableView!
    @IBOutlet var backBnt : UIButton!
    
    let indentifierString = "ClaimHistoryCell"
    let service : Services = Services()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cardInfo : CardInfomationViewController = CardInfomationViewController()
    
    var dataSource: [GifHistoryThumb] = []
    var mainViewController : ViewController!
    var carInfoArray : [Dictionary<String, AnyObject>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.initDataMock()
        // Do any additional setup after loading the view.
        self.historyTbV.register(UINib.init(nibName: "ClaimHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: self.indentifierString)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.removeAll()
        self.carInfoArray.removeAll()
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func BackAction(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initDataMock() {
        
        let item1 = GifHistoryThumb.init(title: "Thẻ cào mobilefone 20.000Đ", time: "21-09-2018")
        let item2 = GifHistoryThumb.init(title: "Thẻ cào mobilefone 50.000Đ", time: "21-09-2018")
        let item3 = GifHistoryThumb.init(title: "Thẻ cào mobilefone 100.000Đ", time: "21-09-2018")
        let item4 = GifHistoryThumb.init(title: "Thẻ cào mobilefone 100.000Đ", time: "21-09-2018")
        let item5 = GifHistoryThumb.init(title: "Thẻ cào mobilefone 100.000Đ", time: "21-09-2018")
        self.dataSource.append(item1)
        self.dataSource.append(item2)
        self.dataSource.append(item3)
        self.dataSource.append(item4)
        self.dataSource.append(item5)
    }
    
    func getData() {
        self.service.HTTPRequestGetMethodWithOnlyToken(token: "Bearer " + self.appDelegate.token, functionPath: "/users/gift", completionHandler: { (data, response,error) in
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
            let item : GifHistoryThumb = GifHistoryThumb.init(
                title: ((($0 as! Dictionary<String, Any>)["gift"] as! Dictionary<String, Any>)["data"] as! Dictionary<String, Any>)["name"] as! String ,
                time: ((($0 as! Dictionary<String, Any>)["gift"] as! Dictionary<String, Any>)["data"] as! Dictionary<String, Any>)["humandateused"] as! String
            )
            self.dataSource.append(item)
            let carinfo : Dictionary<String, AnyObject> = ($0 as! Dictionary<String, Any>)["gift"] as! Dictionary<String, AnyObject>
            self.carInfoArray.append(carinfo)
        }
        DispatchQueue.main.async {
            self.historyTbV.reloadData()
        }
    }
}
