//
//  GameMD.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/11/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation

class Jobs : NSObject {
    var title : String = ""
    var point :  String = ""
    var time  = 1000
    var total : String = ""
    
    override init() {
        super.init()
    }
    init(title: String, point: String, time: Int, total: String) {
        self.title = title
        self.point = point
        self.time = time
        self.total = total
    }
}

class JobDetail: NSObject {
    var title : String = ""
    var subTitle :  String = ""
   
    override init() {
        super.init()
    }
    init(title: String, subTitle: String) {
       self.title = title
       self.subTitle = subTitle
    }
}





