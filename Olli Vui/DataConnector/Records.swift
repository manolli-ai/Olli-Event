//
//  Records.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/19/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class RecordConnector  {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func fectchRecords(completeHandler: @escaping ([Records]) ->Void ) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Records")
        var result: [Records] = []
        //        request.predicate = NSPredicate(format: "user.username != %@", "man")
        request.returnsObjectsAsFaults = false
        do {
            let records = try context.fetch(request)
            for data in records as! [Records] {
                result.append(data)
            }
            completeHandler(result)
        } catch {
            print("Failed")
        }
    }
    func AddRecord(record:NSArray) {//, user: Users) {
        let context = appDelegate.persistentContainer.viewContext
        let entityRecord = NSEntityDescription.entity(forEntityName: "Records", in: context)
        
        record.map{
            if(self.checkExitGame(gameId: ($0 as! Dictionary<String, Any>)["id"] as! String)) {
                let newRecord = NSManagedObject(entity: entityRecord!, insertInto: context)
                newRecord.setValue(($0 as! Dictionary<String, Any>)["id"], forKey: "id")
                newRecord.setValue(($0 as! Dictionary<String, Any>)["title"], forKey: "title")
                newRecord.setValue(($0 as! Dictionary<String, Any>)["type"], forKey: "type")
                newRecord.setValue(($0 as! Dictionary<String, Any>)["cover"], forKey: "cover")
                newRecord.setValue(($0 as! Dictionary<String, Any>)["datecreated"], forKey: "datecreated")
                newRecord.setValue(($0 as! Dictionary<String, Any>)["humandatecreated"], forKey: "humandatecreated")
                newRecord.setValue((($0 as! Dictionary<String, Any>)["status"] as! Dictionary<String,Any>)["label"], forKey: "label")
                newRecord.setValue((($0 as! Dictionary<String, Any>)["status"] as! Dictionary<String,Any>)["value"], forKey: "value")
                newRecord.setValue((($0 as! Dictionary<String, Any>)["status"] as! Dictionary<String,Any>)["style"], forKey: "style")
//                newRecord.setValue(user, forKey: "user")
            }
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }

    func checkExitGame(gameId: String) ->Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Records")
        request.returnsObjectsAsFaults = false
        do {
            let records = try context.fetch(request)
            for data in records as! [Records] {
                if (gameId == data.id) {
                    return false
                }
            }

        } catch {
            print("Failed")
        }
        return true
    }
}
