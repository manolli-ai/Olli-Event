//
//  ServicesConstant.swift
//  Olli Vui
//
//  Created by HuynhMinhMan on 1/14/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation

class ServicesConstant  {
    let  baseURL:String = "https://vui.olli.vn"
    let versionPath: String = "/api/v1"
    let firebaseDomain: String = "https://olli-event-app.firebaseio.com"
    let filePath = Bundle.main.path(forResource: "tinh", ofType: "json")
    
    func initDataForProvince() -> NSArray {
        var result : NSArray = [""]
        let data = NSData(contentsOfFile: self.filePath!)
        do {
            // encoding with utf8
//            let jsonString = try? String(contentsOfFile: self.filePath!, encoding: String.Encoding.utf8)
            
            let jsonData = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)
            result = jsonData as! NSArray
        }
        catch {
            //Handle error
        }
        return result
    }
}
