//
//  SignInViewController.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/25/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController, LoginButtonDelegate {
    
    
    @IBAction func signInByGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
         if let error = error {
           print(error.localizedDescription)
           return
         }
         guard let accessToken = AccessToken.current?.tokenString else {
             return
         }
         let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let loginButton = FBLoginButton(permissions: [ .publicProfile, .email ])
               loginButton.center = view.center
               loginButton.delegate = self
                      view.addSubview(loginButton)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
