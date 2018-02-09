//
//  AccountMD.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/8/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation

class Account: NSObject{
    var authToken: String = ""
    var expries: String = ""
    var accountType: String = ""
    override init() {
        super.init()
    }
    init(authToken: String, expries: String, accountType: String) {
        self.authToken = authToken
        self.expries = expries
        self.accountType = accountType
    }
}
