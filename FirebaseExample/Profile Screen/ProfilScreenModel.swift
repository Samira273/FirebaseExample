//
//  ProfileModel.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/25/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase

class ProfilScreenModel {
     
    var profile = Profile()
    var profileScreenPresenter : ProfileScreenPresenter?
    
    func uploadDataFor(photo: Data, ofType: PicType) {
        var storage = Storage.storage()
        var imageRef : StorageReference
        storage = Storage.storage(url:"gs://fir-example-c00d9.appspot.com")
        let storageRef = storage.reference()
        let randomIntger = Int(arc4random_uniform(42))
        switch ofType {
        case .profilePic:
            imageRef = storageRef.child("profilePic\(randomIntger)")
        case .coverPic:
            imageRef = storageRef.child("coverPic\(randomIntger)")
        }
        let _ = imageRef.putData(photo, metadata: nil) { (metadata, error) in
          imageRef.downloadURL { (url, error) in
            guard let photoDownloadURL = url else {
              return
            }
            switch ofType {
            case .profilePic:
                self.profile.profilePicUrl = photoDownloadURL.absoluteString
            case .coverPic:
                self.profile.coverPicUrl = photoDownloadURL.absoluteString
            }
            self.profileScreenPresenter?.sendData(profile: self.profile)
          }
        }
    }
    
    func retrieveDataFromFireStore() {
        let db = Firestore.firestore()
        let docRef = db.collection("Profiles").document("T4JQzJBWl5HcmPrlX6Ka")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print(document.data()?["email"]! ?? "no value")
                self.profile.email = document.data()?["email"] as? String
                self.profile.firstName = document.data()?["firstName"] as? String
                self.profile.firstName = document.data()?["firstName"] as? String
                self.profile.lastName = document.data()?["lastName"] as? String
                self.profile.profilePicUrl = document.data()?["profilePicUrl"] as? String
                self.profile.coverPicUrl = document.data()?["coverPicUrl"] as? String
                self.profileScreenPresenter?.sendData(profile: self.profile )
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
