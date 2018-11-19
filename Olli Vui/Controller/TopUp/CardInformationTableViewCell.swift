//
//  CardInformationTableViewCell.swift
//  Olli Vui
//
//  Created by ManHuynh on 10/5/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

protocol CardInfoDetailProtocol : AnyObject {
    func copyCode(value : String)
}

class CardInformationTableViewCell: UITableViewCell {
    
    weak var delegate: CardInfoDetailProtocol?
    
    @IBOutlet var title: UILabel!
    @IBOutlet var titleBnt : UIButton!
    var key: String = ""
    var value : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func UpdateUI() {
        self.title.text = self.key
        if(self.key.range(of: "Mã") != nil) {
            self.titleBnt.setTitleColor(.blue, for: .normal)
        }
        else {
            self.titleBnt.setTitleColor(.black, for: .normal)
        }
        self.titleBnt.setTitle(self.value, for: .normal)
    }
    @IBAction func coppyToClipBoard(sender : Any) {
         if(self.key.range(of: "Mã") != nil) {
            self.delegate?.copyCode(value: self.value)
        }
    }
    
}
