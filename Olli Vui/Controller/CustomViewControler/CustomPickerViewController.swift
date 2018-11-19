//
//  CustomPickerViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 5/14/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import UIKit
protocol CustomPickerProtocol {
    func setTitleForItem(id : Int, title : String)
    func updateDefaultValuew(title: String)
}

class CustomPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerView : UIPickerView!
    @IBOutlet var cancelBnt : UIButton!
    @IBOutlet var doneBnt : UIButton!
    @IBOutlet var overlapBnt : UIButton!
    
    var indexOfRegion = 0
    var indexOfDOB = 0
    var typeOfPicker : String = ""
    var titleValue : String = ""
    var delegate : CustomPickerProtocol!
    var data : NSArray = [""]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title : String = ""
        if(self.typeOfPicker == "region") {
            title = (self.data[row] as! NSDictionary)["label"] as! String
        }
        else {
            title = self.data[row] as! String
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(self.typeOfPicker == "region") {
            self.titleValue = (self.data[row] as! NSDictionary)["label"] as! String
            self.indexOfRegion = ((self.data[row] as! NSDictionary)["value"] as! Int) - 1
        }
        else {
            self.titleValue = (self.data[row] as? String)!
            self.indexOfDOB = row
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setIndexOfRegion(id : Int) {
        self.indexOfRegion = id
    }
    func setIndexOfDOB(id : Int) {
        self.indexOfDOB = id
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleValue = ""
        if(self.typeOfPicker == "region") {
            self.setDefaultValue(row: self.indexOfRegion)
        }
        else {
            self.setDefaultValue(row: self.indexOfDOB)
        }
    }
    
    func setDefaultValue(row : Int) {
        DispatchQueue.main.async {
            self.pickerView.selectRow(row, inComponent: 0, animated: true)
        }
    }
    
    func initDataSource(data: NSArray) {
        self.data = data
    }
    
    @IBAction func overlapAction(sender : Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func cancelAction(sender: Any) {
        self.view.removeFromSuperview()
    }
    @IBAction func doneAction(sender : Any) {
        if(self.titleValue == "") {
            if(self.typeOfPicker == "region") {
                self.titleValue = (self.data[self.indexOfRegion] as! NSDictionary)["label"] as! String
            }
            else {
                self.titleValue = self.data[self.indexOfDOB] as! String
            }
        }
        self.delegate.setTitleForItem(id: self.indexOfRegion, title: self.titleValue)
        self.view.removeFromSuperview()
    }
    
}
