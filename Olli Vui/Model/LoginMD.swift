//
//  LoginMD.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/8/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
class Login: NSObject {
    var email: String = ""
    var password: Password  = Password()
    override init() {
        super.init()
    }
    init(email: String, password: Password) {
        self.email = email
        self.password = password
    }
    
}
class Password: NSObject {
    var oauthUid: String = ""
    var oauthAccessToken: String = ""
    var oauthInfo: OauthInfo = OauthInfo()
    override init() {
        super.init()
    }
    init(oauthUid: String, oauthAccessToken: String, oauthInfo: OauthInfo) {
        self.oauthUid =  oauthUid
        self.oauthAccessToken = oauthAccessToken
        self.oauthInfo = oauthInfo
    }
}

class OauthInfo: NSObject {
    var id: String = ""
    var email: String = ""
    var name: String = ""
    var first_name: String = ""
    var last_name: String = ""
    var gender: String = ""
    var picture: Picture = Picture()
    override init() {
        super.init()
    }
    init(id: String, email: String, name: String, first_name: String, last_name: String, gender: String, picture: Picture)
    {
        self.id = id
        self.email = email
        self.name = name
        self.first_name = first_name
        self.last_name = last_name
        self.gender = gender
        self.picture = picture
    }
}

class Picture: NSObject {
    var data: Data1 = Data1()
    override init() {
        super.init()
    }
     init(data: Data1) {
        self.data = data
    }
}

class  Data1: NSObject {
    var url: String = ""
    override init() {
        super.init()
    }
    init(url: String) {
        self.url = url
    }
}
class NewAccount: NSObject {
    var fullname: String = ""
    var email: String = ""
    var password: String = ""
    var repeatpassword: String = ""
    override init() {
        super.init()
    }
    init(fullname: String, email: String, password: String) {
        self.fullname = fullname
        self.email = email
        self.password = password
        self.repeatpassword = password
    }
}
class Questions: NSObject {
    var records: Any = []
    override init() {
        super.init()
    }
    init(records: Any) {
        self.records = records
    }
}
class changePassRequest: NSObject {
    var email: String = ""
    override init() {
        super.init()
    }
    init(email: String) {
        self.email = email
    }
}
class changePassResponse: NSObject {
    var result: String = ""
    override init() {
        super.init()
    }
    init(result: String) {
        self.result = result
    }
}
