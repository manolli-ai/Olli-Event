//
//  JobDetailTableViewCell.swift
//  Olli Vui
//
//  Created by ManHuynh on 9/27/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class JobDetailTableViewCell: UITableViewCell {

    @IBOutlet var title : UILabel!
    @IBOutlet var subTitle : UILabel!
    var titleTxt = ""
    var subTitleTxt = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        self.title.text = titleTxt
        self.subTitle.text = subTitleTxt
    }
}
