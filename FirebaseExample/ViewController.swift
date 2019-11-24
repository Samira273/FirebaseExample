//
//  ViewController.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/19/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import FirebaseAuth
import FBSDKCoreKit

class ViewController: UIViewController, LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let _ = error {
            // ...
            return
          }
          // User is signed in
          // ...
            print("user signed in with facebook")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("user did sign out from facebook")
    }
    

    @IBAction func signInByGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let loginButton = FBLoginButton(permissions: [ .publicProfile, .email ])
               loginButton.center = view.center
        loginButton.delegate = self
               view.addSubview(loginButton)
    }
}

