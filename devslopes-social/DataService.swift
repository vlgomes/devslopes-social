//
//  DataService.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 06/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService{
    
    static let dataService = DataService()
    
    //as this is a singleton, this are all global variables
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE:FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_POSTS:FIRDatabaseReference{
        return _REF_POSTS
    }
    
    var REF_USERS:FIRDatabaseReference{
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid:String, userData: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
}
