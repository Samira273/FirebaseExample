//
//  ViewController.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/19/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {



    @IBAction func signInByGoogle(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Do any additional setup after loading the view.
    }


}

