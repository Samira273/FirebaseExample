//
//  ProfileViewController.swift
//  FirebaseExample
//
//  Created by Samira.Marassy on 11/25/19.
//  Copyright © 2019 Samira.Marassy. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import PixelEditor
import PixelEngine

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PixelEditViewControllerDelegate {
    
    @IBOutlet private weak var coverPicImageView: UIImageView!
    @IBOutlet private weak var profilePicImageView: UIImageView!
    @IBOutlet private weak var profileName: UILabel!
    private var choosenCoverPic: UIImage?
    private var choosenProfilePic: UIImage?
    private var editedCoverPic: UIImage?
    private var editedProfilePic: UIImage?
    var imagePicker = UIImagePickerController()
    private var choosenPicType : PicType?
    private var editPicType : PicType?
    var profileScreenPresenter = ProfileScreenPresenter()
    private var editImageController : PixelEditViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profilePicTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profilePicTapped(tapGestureRecognizer:)))
        profilePicImageView.addGestureRecognizer(profilePicTapGestureRecognizer)
        let coverPicTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(coverPicTapped(tapGestureRecognizer:)))
        coverPicImageView.addGestureRecognizer(coverPicTapGestureRecognizer)
        profileScreenPresenter.profileViewController = self
        profileScreenPresenter.getDataFromFireStore()
        // Do any additional setup after loading the view.
    }
    
    @objc func profilePicTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        choosenPicType = .profilePic
        selectPicFromGallery()
    }
    
    @objc func coverPicTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("cover pic tapped")
        choosenPicType = .coverPic
        selectPicFromGallery()
    }
    
    func goToEditController(with image: UIImage, ofType: PicType) {
        editPicType = ofType
         editImageController = PixelEditViewController(image: image)
        editImageController?.delegate = self
        let navigationController = UINavigationController(rootViewController: editImageController ?? UIViewController())
        self.present(navigationController, animated: true, completion: nil)
        
 //       uploadSelectedPhoto(ofType: ofType)
    }
    
    func uploadSelectedPhoto(ofType: PicType) {
        var photoCompressed = Data()
        switch ofType {
        case .profilePic:
            photoCompressed = editedProfilePic?.jpeg(.lowest) ?? Data()
            profileScreenPresenter.uploadPhoto(photo: photoCompressed, ofType: .profilePic)
        case .coverPic:
            photoCompressed = editedCoverPic?.jpeg(.lowest) ?? Data()
            profileScreenPresenter.uploadPhoto(photo: photoCompressed, ofType: .coverPic)
        }
    }
    
    func selectPicFromGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        switch choosenPicType {
        case .coverPic:
            choosenCoverPic = image
            editedCoverPic = choosenCoverPic
          //  uploadSelectedPhoto(ofType: .coverPic)
            imagePicker.dismiss(animated: true, completion: nil)
            goToEditController(with: choosenCoverPic ?? UIImage(), ofType: .coverPic)
        case .profilePic:
            choosenProfilePic = image
            editedProfilePic = choosenProfilePic
            imagePicker.dismiss(animated: true, completion: nil)
            goToEditController(with: choosenProfilePic ?? UIImage(), ofType: .profilePic)
         //   uploadSelectedPhoto(ofType: .profilePic)
        case .none:
            print("none")
        }
    }
  
    func roundCoverPicImageView() {
        let path = UIBezierPath(roundedRect:coverPicImageView.bounds,
                                byRoundingCorners:[.topRight, .topLeft],
                                cornerRadii: CGSize(width: 10, height:  10))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        coverPicImageView.layer.mask = maskLayer
    }
    
    func circleProfilePicImageView() {
        profilePicImageView.layer.borderWidth = 4
        profilePicImageView.layer.masksToBounds = false
        profilePicImageView.layer.borderColor = UIColor.white.cgColor
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height/2
        profilePicImageView.clipsToBounds = true
    }
    
    func displayProfile(profile: Profile) {
        roundCoverPicImageView()
        circleProfilePicImageView()
        coverPicImageView.sd_setImage(with: URL(string: profile.coverPicUrl ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        profilePicImageView.sd_setImage(with: URL(string: profile.profilePicUrl ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        let name = (profile.firstName ?? "") + " " + (profile.lastName ?? "")
        profileName.text = name
    }
    
    func pixelEditViewController(_ controller: PixelEditViewController, didEndEditing editingStack: EditingStack) {
        print("done editing")
                switch editPicType {
                case .profilePic:
                    editedProfilePic = editImageController?.editingStack.makeRenderer().render()
                    uploadSelectedPhoto(ofType: .profilePic)
                case .coverPic:
                    editedCoverPic = editImageController?.editingStack.makeRenderer().render()
                    uploadSelectedPhoto(ofType: .coverPic)
                case .none:
                    print("failed isA lol")
        }

        controller.dismiss(animated: true, completion: nil)
//        self.navigationController?.popToViewController(self, animated: true)
        
    }

    func pixelEditViewControllerDidCancelEditing(in controller: PixelEditViewController) {
        print("cancel editing")
        self.navigationController?.popToViewController(self, animated: true)
    }
    
}

enum PicType: String {
    case profilePic
    case coverPic
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}



