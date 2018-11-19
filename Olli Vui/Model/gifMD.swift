//
//  gifMD.swift
//  Olli Vui
//
//  Created by Man Huynh on 4/11/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation

class GifCardMD : NSObject {
    // this model just used for single select - need build another model for multi select
    
    var name : String = ""
    var quantity : String = ""
    var required : String = ""
    var cover : NSURL = NSURL()
    override init() {
        super .init()
    }
    init(productName: String, quantity : String, required : String, cover : NSURL) {
        self.name = productName
        self.quantity = quantity
        self.required = required
        self.cover = cover
    }
}

class GifHistoryThumb : NSObject {
    var title : String = ""
    var time : String = ""
    override init() {
        super.init()
    }
    init(title : String, time : String) {
        self.title = title
        self.time = time
    }
}

class GifInformationDetail : NSObject {
    var key : String = ""
    var value : String = ""
    override init() {
        super.init()
    }
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
