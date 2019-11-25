//
//  ProfileModel.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/25/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ProfilScreenModel {
    
    func retrieveDataFromFireStore(){
        let db = Firestore.firestore()
        let docRef = db.collection("Profiles").document("T4JQzJBWl5HcmPrlX6Ka")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
