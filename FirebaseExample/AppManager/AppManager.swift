//
//  AppManager.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/25/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit

class AppManager : UIResponder {
    
    static var window : UIWindow?
    
    static func prepareWindowWithScene(scene : UIScene) {

        if #available(iOS 13, *) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
                   window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                   window?.windowScene = windowScene
            makeVisibleToSignInViewController()
        } else {
        }
    }
    
    static func prepareWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        makeVisibleToSignInViewController()
    }
    
    static func makeVisibleToSignInViewController() {
     //   AppManager.window?.rootViewController = SignInViewController(nibName: nil, bundle: nil)
        AppManager.window?.rootViewController = ProfileViewController(nibName: nil, bundle: nil)
        AppManager.window?.makeKeyAndVisible()
    }
}
