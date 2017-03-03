//
//  FeedVC.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 03/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        
        print ("VASCO : ID removed from keychain \(keychainResult)")
        
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
