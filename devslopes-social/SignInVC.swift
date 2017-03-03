//
//  ViewController.swift
//  devslopes-social
//
//  Created by Vasco Gomes on 02/03/2017.
//  Copyright © 2017 Vasco Gomes. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet var emailField: FancyField!
    @IBOutlet var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        
        let facebookLogin =  FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result,error) in
            if error != nil {
            //VASCO é porque usando o Firebase, o log tem mta informação e assim fica mais fácil de perceber onde está o erro
                print("VASCO: Unable to authenticate to Facebook - \(error)")
            } else if result?.isCancelled == true{
                print("VASCO: User cancelled facebook authentication")
            } else {
                print("VASCO: Succesfully authenticated with Facebook")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("VASCO: Unable to authenticate to Firebase - \(error)")
            } else {
                print("VASCO: Succesfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("VASCO: Succesfully authenticated with email with Firebase")
                } else {
                    print("VASCO: Unable to authenticate with email to Firebase. Creating a user")
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("VASCO: Unable to authenticate to Firebase - \(error)")
                        } else {
                            print("VASCO: Succesfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }
}

