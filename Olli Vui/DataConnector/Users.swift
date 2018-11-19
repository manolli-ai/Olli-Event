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
    var Token : String = ""
    func initUserData()  {
//        let context = appDelegate.persistentContainer.viewContext
    }

    func AddUser(user: Dictionary<String,Any>, token: String)  {
//        print(user)
       self.appDelegate.token = token
        UserDefaults.standard.setValue("1000", forKey: "PolicyLimit") // hard code 20 user["limitnumber"] as? String
        //delete all user record before add new user
        self.deleteAllUserRecord()
//        if let id = user["id"] as? String {
//            if (self.CheckExitID(id: id)) {
                let context = appDelegate.persistentContainer.viewContext
                let entityUser = NSEntityDescription.entity(forEntityName: "Users", in: context)
                let newUser = NSManagedObject(entity: entityUser!, insertInto: context)
                newUser.setValue(user["id"] as? String , forKey: "id")
                newUser.setValue(user["screenname"] as? String , forKey: "screenname")
                newUser.setValue(user["fullname"] as? String , forKey: "fullname")
                newUser.setValue(user["email"] as? String , forKey: "email")
//                newUser.setValue(user["address"] as? String , forKey: "address")
//                newUser.setValue(user["password"] as? String , forKey: "password")
                newUser.setValue(user["groupid"] as? String , forKey: "groupid")
                newUser.setValue(user["avatar"] as? String , forKey: "avatar")
//                newUser.setValue(user["gender"] as? String , forKey: "gender")
//                newUser.setValue(user["status"] as? String, forKey: "status")
//                newUser.setValue(user["dob"] as? String, forKey: "dob")
                newUser.setValue(user["oauthuid"] as? String, forKey: "oauthuid")
                newUser.setValue(token , forKey: "oauthaccesstoken")
//                newUser.setValue(user["oauthprovider"] as? String, forKey: "oauthprovider")
//                newUser.setValue(user["onesignalid"] as? String , forKey: "onesignalid")
//                newUser.setValue(user["state"] as? String, forKey: "state")
//                newUser.setValue(user["datecreated"] as? String , forKey: "datecreated")
//                newUser.setValue(user["datelastchangepassword"] as? String, forKey: "datelastchangepassword")
//                newUser.setValue(user["datemodified"] as? String, forKey: "datemodified")
                newUser.setValue(user["mobilenumber"] as? String, forKey: "mobilenumber")
//                newUser.setValue(user["isverified"] as? String, forKey: "isverified")
//                newUser.setValue(user["verifytype"] as? String , forKey: "verifytype")
//                newUser.setValue(user["totalcoin"] as? String, forKey: "totalcoin")
                newUser.setValue(user["isprofileupdated"].debugDescription.components(separatedBy: "(")[1].components(separatedBy: ")")[0], forKey: "isprofileupdated")
        
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
//            } else {
//                print("user is exited")
//            }
//        }
    }
    func DeleteUser() {
        
    }
    func UpdateUser(key : String , value : String) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do {
            let result = try context.fetch(request)
            if(result.count != 0) {
                (result[0] as AnyObject).setValue(value, forKey: key)
            }
        } catch {
            print("Failed")
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    func setUserToken(token : String) {
        self.Token = token
    }
    func getUserToken() -> String {
        return self.Token
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
    
    func fetchUserPhoneNumber(phoneNumber: String) -> Users {
        var user: Users = Users()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [Users] {
                if(data.mobilenumber == phoneNumber) {
                    user = data
                }
            }
        } catch {
            print("Failed")
        }
        return user
    }
    
    func fetchUser() -> Users {
        var user: Users = Users()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if(result.count > 0) {
                user = result[0] as! Users
            }
            else {
                
            }
        } catch {
            print("Failed")
        }
        return user
    }
    func checkExitData() -> Bool {
        var user: Users = Users()
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            if(result.count > 0) {
               return true
            }
            else {
                return false
            }
        } catch {
            print("Failed")
        }
        return true
    }
    
    func deleteAllUserRecord() {
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func CheckExitID(id:String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [Users] {
                if(data.id == id) {
                    return false
                }
            }
        } catch {
            print("Failed")
        }
        return true
    }
    func CheckExitPhoneNumber(phoneNumber:String) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [Users] {
                if(data.mobilenumber?.description == phoneNumber) {
                    return true
                }
            }
        } catch {
            print("Failed")
        }
        return false
    }
}

