//
//  CardInfomationViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 5/11/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD

class CardInfomationViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CardInfoDetailProtocol {
    
    func copyCode(value: String) {
        let alert = UIAlertController.init(title: "Bạn có muốn sao chép mã", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            switch action.style{
            case .default:
                do {
                    alert.dismiss(animated: true, completion: nil)
                }
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style{
            case .default:
                do {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = value
                }
            case .cancel:
                print("cancel")
        
            case .destructive:
                print("destructive")
        }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet var infoView: UIView!
    @IBOutlet var priceLB : UILabel!
    @IBOutlet var expireLB : UILabel!
    @IBOutlet var numvberLB : UILabel!
    @IBOutlet var backBnt : UIButton!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var imgProductName : UIImageView!
    @IBOutlet var contactLB : UILabel!
    @IBOutlet var viewCodeBnt : UIButton!
    
    var cardInfo : Dictionary<String, AnyObject> = [:]
    var data : Dictionary<String, AnyObject> = [:]
    var priceTitle : String = ""
    let indentifierString = "CardInformationViewCell"
    var dataSource : [GifInformationDetail] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CardInformationTableViewCell = tableView.dequeueReusableCell(withIdentifier: indentifierString, for: indexPath) as! CardInformationTableViewCell
        cell.delegate = self
        cell.key = self.dataSource[indexPath.row].key
        cell.value = self.dataSource[indexPath.row].value
        cell.UpdateUI()
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "CardInformationTableViewCell", bundle: nil), forCellReuseIdentifier: indentifierString)
        self.setUpUI()
        self.contactLB.frame = CGRect.init(x: 0, y: self.tableView.frame.origin.y + 10 ,width: self.view.frame.size.width, height: 30)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parseCardInfoJsonToObject(json: self.cardInfo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpUI() {
        self.infoView.layer.cornerRadius = 10
        self.infoView.layer.borderWidth = 2.0
        self.infoView.layer.borderColor =  UIColor.init(red: 118/255, green: 147/255, blue: 211/255, alpha: 1).cgColor
        self.viewCodeBnt.layer.cornerRadius = 20
    }
    func updateUI() {

        if(self.dataSource.count > 0) {
            self.contactLB.isHidden = true
        }else {
            self.contactLB.isHidden = false
        }
        if let url : String = self.cardInfo["data"]!["cover"] as? String {
            UIImage.downloadFromRemoteURL(NSURL.init(string: url)! as URL, completion: { image, error in
                guard let image = image, error == nil else { print(error!);return }
                self.imgProductName.image = image
            })
        }
    }
    
    @IBAction func backAction(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func parseCardInfoJsonToObject(json :  Dictionary<String, AnyObject>){
        
            self.data.removeAll()
            self.dataSource.removeAll()
            let dataJ = json["data"]!["stocks"] as! Dictionary<String, AnyObject>
            let dataK = dataJ["data"] as! NSArray
            dataK.map {
                let key = ((($0 as! Dictionary<String, Any>)["attribute"] as! Dictionary<String, Any>)["data"] as! Dictionary<String, Any>)["name"]
                let value = ($0 as! Dictionary<String, Any>)["value"]
                let item: GifInformationDetail = GifInformationDetail.init(key: key as! String, value: value as! String)
                self.dataSource.append(item)
            }
        
        self.priceTitle = (json["data"]!["name"] as! String).components(separatedBy: " ").last!
        self.updateUI()
        self.tableView.reloadData()
    }
    func getImageFromProductName(productName : String) ->UIImage {
        if(productName == "Viettel") {
            return UIImage.init(named: "Viettel big logo")!
        }
        else if(productName == "Mobifone") {
            return UIImage.init(named: "Mobifone big logo")!
        }
        else if(productName == "Vinaphone") {
            return UIImage.init(named: "Vinaphone big logo")!
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

    @IBAction func coppyToClipBoard(sender : Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string =  self.numvberLB.text
    }
    @IBAction func homeAction(sender : Any) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    @IBAction func openHomeFace(sender: Any) {
        if let url = URL(string: "https://www.facebook.com/notes/olli-technology/%C4%91i%E1%BB%81u-ki%E1%BB%87n-%C3%A1p-d%E1%BB%A5ng-c%C3%A1c-e-voucher/1906657802723337/"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 13, y: 13)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @IBAction func showCodeView(sender : Any) {
        let image = generateQRCode(from: "Hacking with Swift is the best iOS coding tutorial I've ever read!")
        KRProgressHUD.showImage(image!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
            KRProgressHUD.dismiss()
        })
    }
    
}
