//
//  RewardStoreViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/14/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit

class RewardStoreViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    let identifiCell: String = "rewardCell"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifiCell, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @IBOutlet var creditTableView: UITableView!
    @IBOutlet var creditLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creditTableView.register(UINib.init(nibName: "RewardStoreTableViewCell", bundle: nil), forCellReuseIdentifier: identifiCell)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
