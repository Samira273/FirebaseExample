//
//  ProfileScreenPresenter.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/25/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import Foundation

class ProfileScreenPresenter {
    
    var profileScreenModel = ProfilScreenModel()
    var profileViewController: ProfileViewController?
    
    func getDataFromFireStore() {
        profileScreenModel.profileScreenPresenter = self
        profileScreenModel.retrieveDataFromFireStore()
    }
    
    func sendData(profile: Profile){
        profileViewController?.displayProfile(profile: profile)
    }
    
    func uploadPhoto(photo: Data, ofType: PicType){
        profileScreenModel.uploadDataFor(photo: photo, ofType: ofType)
    }
}
