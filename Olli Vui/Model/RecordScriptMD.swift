//
//  RecordScriptMD.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/2/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
class RecordScripts : NSObject {
    var id : String = ""
    var command : String = ""
    var text : String = ""
    var dateCreated : String = ""
    var humanDateCreated : String = ""
    var status : Status = Status();
    var path : URL = URL.init(string: "root")!
    override init() {
        super .init()
    }
    init(id : String, comnand : String, text : String, dateCreated : String, humanDateCreated : String , status : Status , path : URL) {
        self.id = id
        self.command = comnand
        self.text = text
        self.dateCreated = dateCreated
        self.humanDateCreated = humanDateCreated
        self.status = status
        self.path = path
    }
}

class Status : NSObject {
    var label : String = ""
    var value : String = ""
    var style : String = ""
    override init() {
        super .init()
    }
    init(label : String , value : String, style : String) {
        self.label = label
        self.value = value
        self.style = style
    }
}
