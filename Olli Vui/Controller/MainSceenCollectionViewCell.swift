//
//  MainSceenCollectionViewCell.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/13/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit
import AVFoundation

protocol MainScreenCellProtocol {
    func GotoGameScreenDetail()
    func GotoHelpcreenDetail(game: Records, limit : Int)
}
class MainSceenCollectionViewCell: UICollectionViewCell {
    var delegate: MainScreenCellProtocol!
    var game: Records = Records()
    var job:Jobs = Jobs()
    var totalAnwsernum : Int = 0
    @IBOutlet var Gamelabel: UILabel!
    @IBOutlet var totalScore: UILabel!
    @IBOutlet var totalTime: UILabel!
    @IBOutlet var totalAnswer: UILabel!
    @IBOutlet var GameImage: UIImageView!
    @IBOutlet var GameButton: UIButton!
    @IBOutlet var startImgV : UIImageView!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func action(_ sender: UIButton) {
//        self.delegate.GotoGameScreenDetail()
        self.delegate.GotoHelpcreenDetail(game: self.game, limit: self.totalAnwsernum)
    }
    func updateUI()  {
        self.totalScore.text = "1000"//String(format: "%@", self.job.point)
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self.totalScore.text!).boundingRect(with: size, options: options, attributes:[NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17)], context: nil)
        self.totalScore.frame.size.width = estimatedFrame.width
        self.startImgV.frame.origin.x = self.totalScore.frame.origin.x + estimatedFrame.width
        self.totalAnwsernum = 1000 - self.job.time
        self.totalAnswer.text = String(format: "%d/1000", self.totalAnwsernum)
    }
}
