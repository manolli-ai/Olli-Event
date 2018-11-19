//
//  JobDetailViewController.swift
//  Olli Vui
//
//  Created by ManHuynh on 9/26/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var mainViewController : ViewController!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let helpDetialView : HelpViewController = HelpViewController()
    var dataSource : [JobDetail] = []
    let indentifierString = "JobDetailCell"
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : JobDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "JobDetailCell", for: indexPath) as! JobDetailTableViewCell
        cell.titleTxt = dataSource[indexPath.row].title
        cell.subTitleTxt = dataSource[indexPath.row].subTitle
        cell.updateUI()
        return cell
    }
    
    @IBOutlet var jobTbv : UITableView!
    @IBOutlet var startBnt : UIButton!
    @IBOutlet var backBnt : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDataMock()
        self.jobTbv.register(UINib.init(nibName: "JobDetailTableViewCell", bundle: nil), forCellReuseIdentifier: indentifierString)
        self.SetUpUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func SetUpUI() {
        self.startBnt.layer.cornerRadius = 20
    }

    func initDataMock()  {

        let item1 = JobDetail.init(title: "Tên công việc", subTitle: "Thu âm câu có sẵn")
        let item2 = JobDetail.init(title: "Đăng bởi" , subTitle: "OLLI Technology" )
        let item3 = JobDetail.init(title: "Ngày đăng", subTitle: "24-10-2018")
        let item4 = JobDetail.init(title: "Ngày hết hạn", subTitle: "14-11-2018")
        let item5 = JobDetail.init(title: "Đối tượng", subTitle: "Tất cả")
        let item6 = JobDetail.init(title: "Số câu", subTitle: "1000")
        let item7 = JobDetail.init(title: "Điểm thưởng", subTitle: "1000")
        let item8 = JobDetail.init(title: "Thời gian", subTitle: "90 phút")
        let item9 = JobDetail.init(title: "Xác thực", subTitle: "Có")
        self.dataSource.append(item1)
        self.dataSource.append(item2)
        self.dataSource.append(item3)
        self.dataSource.append(item4)
        self.dataSource.append(item5)
        self.dataSource.append(item6)
        self.dataSource.append(item7)
        self.dataSource.append(item8)
        self.dataSource.append(item9)
        
    }
    
    @IBAction func StartAction(sender : Any) {
        self.helpDetialView.mainViewController = self.mainViewController
        self.present(self.helpDetialView, animated: true, completion: nil)
    }

    @IBAction func BackAction(sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
