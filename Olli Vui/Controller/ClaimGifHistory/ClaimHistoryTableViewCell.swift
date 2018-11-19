//
//  ClaimHistoryTableViewCell.swift
//  Olli Vui
//
//  Created by ManHuynh on 10/1/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class ClaimHistoryTableViewCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var time: UILabel!
    var titleStr = ""
    var timeStr = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI() {
        self.title.text = titleStr
        self.time.text = timeStr
    }
}
