//
//  GifStoreCollectionViewCell.swift
//  Olli Vui
//
//  Created by ManHuynh on 6/5/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class GifStoreCollectionViewCell: UICollectionViewCell {
    @IBOutlet var image : UIImageView!
    @IBOutlet var title : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateLayOut() {
        self.image.frame.size.height = self.image.frame.size.width
    }
}
