//
//  TopUpCardTableViewCell.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/13/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
import KRProgressHUD

class TopUpCardTableViewCell: UITableViewCell {
    @IBOutlet var title : UILabel!
    @IBOutlet var righTopView : UIView!
    @IBOutlet var rightView : UIView!
    @IBOutlet var imView : UIImageView!
    @IBOutlet var claimBnt : UIButton!
    @IBOutlet var price : UILabel!
    var indexCell : NSInteger = 0
    var giffcard : GifCardMD = GifCardMD()
    let service : Services = Services()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpUI() {
        self.parseNameToIndexCell(name: self.giffcard.name)
        self.claimBnt.layer.cornerRadius = 3.0
        self.righTopView.layer.cornerRadius = 3.0
        self.rightView.layer.cornerRadius = 3.0
        self.claimBnt.setTitle(self.giffcard.required + " Points", for: UIControlState.normal)
        if(self.indexCell == 0) {
            //Viettel
            self.rightView.backgroundColor = UIColor.init(red: 14/255, green: 119/255, blue: 119/255, alpha: 1)
            self.imView.frame = CGRect.init(x: self.righTopView.frame.size.width/2 - 25, y: 0, width: 50, height: 40)
            self.imView.image = UIImage.init(named: "viettel_tran")
        }
        else if(indexCell == 1) {
            //mobifone
            self.rightView.backgroundColor = UIColor.init(red: 2/255, green: 100/255, blue: 158/255, alpha: 1)
            self.imView.frame = CGRect.init(x: 0, y: 0, width: self.righTopView.frame.size.width, height:self.righTopView.frame.size.height)
            self.imView.image = UIImage.init(named: "mobifone")
        }
        else if(indexCell == 2) {
            //vinaphone
           self.rightView.backgroundColor = UIColor.init(red: 10/255, green: 163/255, blue: 226/255, alpha: 1)
            self.imView.frame = CGRect.init(x: 0, y: 0, width: self.righTopView.frame.size.width, height:self.righTopView.frame.size.height)
            self.imView.image = UIImage.init(named: "vinaphone")
        }
    }
    func parseNameToIndexCell(name : String) {
        let arrayCharacters = name.components(separatedBy: " ")
        if(arrayCharacters.first! == "[Viettel]") {
            self.indexCell = 0
        }
        else if(arrayCharacters.first! == "[Mobiphone]") {
            self.indexCell = 1
        }
        else if(arrayCharacters.first! == "[Vinaphone]") {
            self.indexCell = 2
        }
        if(arrayCharacters.last! == "20k") {
            self.price.text = "20.000 VNĐ"
        }
        else if(arrayCharacters.last! == "50k") {
             self.price.text = "50.000 VNĐ"
        }
        else if(arrayCharacters.last! == "100k") {
             self.price.text = "100.000 VNĐ"
        }
    }
    @IBAction func claimCard(sender: Any) {
        self.service.HTTPRequestPostMethodWithToken(token:"Bearer " + self.appDelegate.token, param: ["name" : self.giffcard.name], functionPath: "/stores/claim", completionHandler: { (data, response,error) in
            do {
                if(data != nil) {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    KRProgressHUD.showSuccess()
                }
                else {
                    //show error
                }
            }catch {
                print(error)
            }
        })
    }
 }
