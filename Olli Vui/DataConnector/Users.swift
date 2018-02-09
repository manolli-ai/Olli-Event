//
//  Users.swift
//  Olli Vui
//
//  Created by Man Huynh on 1/17/18.
//  Copyright © 2018 Man Huynh. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UsersData  {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    func initUserData()  {
//        let context = appDelegate.persistentContainer.viewContext
    }

    func AddUser(user: Dictionary<String,Any>, token: String)  {
        if (self.CheckExitID(email: user["email"]! as! String)) {
            let context = appDelegate.persistentContainer.viewContext
            let entityUser = NSEntityDescription.entity(forEntityName: "Users", in: context)
            let newUser = NSManagedObject(entity: entityUser!, insertInto: context)
            newUser.setValue(user["id"], forKey: "id")
            newUser.setValue(user["screenname"], forKey: "screenname")
            newUser.setValue(user["fullname"], forKey: "fullname")
            newUser.setValue(user["email"], forKey: "email")
            newUser.setValue(user["address"], forKey: "address")
            newUser.setValue(user["password"], forKey: "password")
            newUser.setValue(user["groupid"], forKey: "groupid")
            newUser.setValue(user["avatar"], forKey: "avatar")
            newUser.setValue(user["gender"], forKey: "gender")
            newUser.setValue(user["status"], forKey: "status")
            newUser.setValue("\(String(describing: user["dob"]))" , forKey: "dob")
            newUser.setValue(user["oauthuid"], forKey: "oauthuid")
            newUser.setValue(token, forKey: "oauthaccesstoken")
            newUser.setValue(user["oauthprovider"], forKey: "oauthprovider")
            newUser.setValue(user["onesignalid"], forKey: "onesignalid")
            newUser.setValue(user["state"], forKey: "state")
            newUser.setValue("\(String(describing: user["datecreated"]))", forKey: "datecreated")
            newUser.setValue("\(String(describing: user["datelastchangepassword"]))", forKey: "datelastchangepassword")
            newUser.setValue("\(String(describing: user["datemodified"]))", forKey: "datemodified")
            newUser.setValue("\(String(describing: user["mobilenumber"]))", forKey: "mobilenumber")
            newUser.setValue(user["isverified"], forKey: "isverified")
            newUser.setValue(user["verifytype"], forKey: "verifytype")
            newUser.setValue(user["totalcoin"], forKey: "totalcoin")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        } else {
            print("user is exited")
        }
    }
    func DeleteUser() {

    }
    func UpdateUser() {
        
    }
    func DeleteAllRecords(tblName: String) {
        let context = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: tblName))
        do {
            try context.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
    func fetchUserData(emai: String) -> Users {
        var user: Users = Users()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
//        request.predicate = NSPredicate(format: "user.username != %@", "man")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [Users] {
                if(data.email == emai) {
                    user = data
                }
            }
        } catch {
            print("Failed")
        }
        return user
    }
    func CheckExitID(email:String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //        request.predicate = NSPredicate(format: "user.username != %@", "man")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [Users] {
                if(data.email == email) {
                    return false
                }
            }
        } catch {
            print("Failed")
        }
        return true
    }
}
