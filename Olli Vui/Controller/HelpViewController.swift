//
//  HelpViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/12/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    @IBOutlet var rewardButton: UIButton!
    @IBOutlet var totalScore: UILabel!
    @IBOutlet var helpView: UIView!
    let mainScreenGameDetail: GameViewController = GameViewController()
    var game: Records!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        self.startButton.setRadiusWithShadow(25)
        self.rewardButton.setRadiusWithShadow(60)
        self.helpView.setRadiusWithShadow(5)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func Start(sender: AnyObject) {
        self.mainScreenGameDetail.game = self.game
        self.navigationController?.pushViewController(self.mainScreenGameDetail, animated: true)
    }
}
