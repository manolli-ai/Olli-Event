//
//  GiffStore.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/13/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
class GiffStore : NSObject {
    var id : String = ""
    var name : String = ""
    var datecreated : String = ""
    var humandatecreated : String = ""
    var attributes : Dictionary<String, Any> = ["" : ""]
    
    override init() {
        super.init()
    }
    init(id : String, name : String, datecreated : String ,humandatecreated : String) {
        self.id = id
        self.name = name
        self.datecreated = datecreated
        self.humandatecreated = humandatecreated
    }
}
