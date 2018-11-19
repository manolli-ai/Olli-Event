//
//  RewardStoreTableViewCell.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/14/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit
import Foundation
class RewardStoreTableViewCell: UITableViewCell {
    @IBOutlet var title : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupUI() {

    }
}
