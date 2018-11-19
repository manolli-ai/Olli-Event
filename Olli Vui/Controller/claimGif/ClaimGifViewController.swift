//
//  ClaimGifViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 5/23/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class ClaimGifViewController: UIViewController {

    @IBOutlet var centerView : UIView!
    @IBOutlet var priceLB : UILabel!
    @IBOutlet var codeLB : UILabel!
    @IBOutlet var detailBnt : UIButton!
    @IBOutlet var copyClipboard : UIButton!
    
    var priceTitle : String = ""
    var cardInfo : Dictionary<String, AnyObject> = [:]
    var data : Dictionary<String, AnyObject> = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func parseCardInfoJsonToObject(json :  Dictionary<String, AnyObject>){
        
        let dataJ = json["data"]!["stocks"] as! Dictionary<String, AnyObject>
        let dataK = dataJ["data"] as! NSArray
        dataK.map {
            let key = ((($0 as! Dictionary<String, Any>)["attribute"] as! Dictionary<String, Any>)["data"] as! Dictionary<String, Any>)["name"]
            let value = ($0 as! Dictionary<String, Any>)["value"]
            self.data.updateValue(value as AnyObject, forKey: key as! String)
        }
        self.priceTitle = (json["data"]!["name"] as! String).components(separatedBy: " ").last!
    }
    
    func getImageFromProductName(productName : String) ->UIImage {
        if(productName == "Viettel") {
            return UIImage.init(named: "viettel_tran")!
        }
        else if(productName == "Mobiphone") {
            return UIImage.init(named: "mobifone")!
        }
        else if(productName == "Vinaphone") {
            return UIImage.init(named: "vinaphone")!
        }
        return UIImage.init(named: "viettel_tran")!
    }
    func parseShortPriceTofullPrice(sPrice: String) -> String {
        var fPrice = ""
        if(sPrice == "20k") {
            fPrice = "20.000 VNĐ"
        }
        else if(sPrice == "50k") {
            fPrice = "50.000 VNĐ"
        }
        else if(sPrice == "100k") {
            fPrice = "100.000 VNĐ"
        }
        return fPrice
    }

    @IBAction func overlapAction(sender : UIButton) {
        self.view.removeFromSuperview()
    }
    @IBAction func detailAction(sender : Any) {
        
    }
    @IBAction func copyAction(sender : Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string =  self.codeLB.text
    }

}
