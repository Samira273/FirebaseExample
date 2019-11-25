//
//  AppDelegate.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/19/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
          GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
          GIDSignIn.sharedInstance().delegate = self
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
       if let _ = error {
         return
       }
       guard let authentication = user.authentication else { return }
       let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                         accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if let _ = error {
          return
        }
        // User is signed in
      
          print("user is signed in")
      }
      }
    
     func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      
     }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      guard let urlScheme = url.scheme else { return false }
        if (urlScheme == "com.googleusercontent.apps.538421270614-h3q0pgoevmkmi5d9nvtts3qdoq41dtsa"){
             return GIDSignIn.sharedInstance().handle(url)
        } else {
             return ApplicationDelegate.shared.application(app, open: url, options: options)
        }
    }
    
}

