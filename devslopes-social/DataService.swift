//
//  DataService.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 06/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORA_BASE = FIRStorage.storage().reference()

class DataService{
    
    static let dataService = DataService()
    
    // DB References
    // as this is a singleton, this are all global variables
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage References
    private var _REF_POST_IMAGES = STORA_BASE.child("post-pics")
    
    
    var REF_BASE:FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_POSTS:FIRDatabaseReference{
        return _REF_POSTS
    }
    
    var REF_USERS:FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference{
        let uid = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var REF_POST_IMAGES:FIRStorageReference{
        return _REF_POST_IMAGES
    }
    
    func createFirebaseDBUser(uid:String, userData: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}
