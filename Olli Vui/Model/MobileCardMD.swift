//
//  MobileCardMD.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/16/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
class MobileCard : NSObject {
    var serial : String  = ""
    var code : String = ""
    var HSD : String = ""
    var nhamang : String = ""
    override init() {
        super.init()
    }
    init(serial: String, code: String, HSD: String, nhamang: String) {
        self.serial = serial
        self.code = code
        self.HSD = HSD
        self.nhamang = nhamang
    }
}
