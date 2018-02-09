//
//  MainSceenCollectionViewCell.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/13/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit

protocol MainScreenCellProtocol {
    func GotoGameScreenDetail()
    func GotoHelpcreenDetail(game: Records)
}
class MainSceenCollectionViewCell: UICollectionViewCell {
    var delegate: MainScreenCellProtocol!
    var game: Records = Records()
    @IBOutlet var Gamelabel: UILabel!
    @IBOutlet var totalScore: UILabel!
    @IBOutlet var GameImage: UIImageView!
    @IBOutlet var GameButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func action(_ sender: UIButton) {
//        self.delegate.GotoGameScreenDetail()
        self.delegate.GotoHelpcreenDetail(game: self.game)
    }
}
