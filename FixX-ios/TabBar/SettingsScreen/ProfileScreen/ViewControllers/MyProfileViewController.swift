//
//  MyProfileViewController.swift
//  FixX-ios
//
//  Created by moutaz hegazy on 6/23/21.
//  Copyright © 2021 moutaz_hegazy. All rights reserved.
//

import UIKit
import Photos

class MyProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var myName: UILabel!
    
    @IBOutlet weak var myEmail: UILabel!
    
    @IBOutlet weak var myPhone: UILabel!
    
    @IBOutlet weak var myPassword: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var chooseImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
        

    @IBAction func EditName(_ sender: UIButton) {
        
        let editNameAlert = UIAlertController(title: "Edit Name", message: "Enter Your Name", preferredStyle: .alert)
        
        editNameAlert.addTextField()
        
        editNameAlert.textFields![0].placeholder = "Enter your name"
        editNameAlert.textFields![0].keyboardType = UIKeyboardType.alphabet
        
        editNameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editNameAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let nameText = editNameAlert.textFields![0].text
            self.myName.text = nameText
        } ))
        
        self.present(editNameAlert, animated: true)
        
        
    }
    
    
    @IBAction func EditEmail(_ sender: UIButton) {
        let editEmailAlert = UIAlertController(title: "Edit Email", message: "Enter Your Email", preferredStyle: .alert)
        
        editEmailAlert.addTextField()
        
        editEmailAlert.textFields![0].placeholder = "Enter your email"
        editEmailAlert.textFields![0].keyboardType = UIKeyboardType.emailAddress
        
        editEmailAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editEmailAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let emailText = editEmailAlert.textFields![0].text
            self.myEmail.text = emailText
        } ))
        
        self.present(editEmailAlert, animated: true)
    }
    
    @IBAction func EditPhone(_ sender: UIButton) {
        let editPhoneAlert = UIAlertController(title: "Edit Phone", message: "Enter Your Phone", preferredStyle: .alert)
        
        editPhoneAlert.addTextField()
        
        editPhoneAlert.textFields![0].placeholder = "Enter your phone number"
        editPhoneAlert.textFields![0].keyboardType = UIKeyboardType.numberPad
        
        editPhoneAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editPhoneAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let phoneText = editPhoneAlert.textFields![0].text
            self.myPhone.text = phoneText
        } ))
        
        self.present(editPhoneAlert, animated: true)
    }
    
    @IBAction func EditPassword(_ sender: UIButton) {
        let editPasswordAlert = UIAlertController(title: "Edit Password", message: "Enter Your Password", preferredStyle: .alert)
        
        editPasswordAlert.addTextField()
        editPasswordAlert.addTextField()
        editPasswordAlert.addTextField()
        
        
        editPasswordAlert.textFields![0].placeholder = "Enter your old password"
        editPasswordAlert.textFields![0].keyboardType = UIKeyboardType.default
        
        editPasswordAlert.textFields![1].placeholder = "Enter your new password"
        editPasswordAlert.textFields![1].keyboardType = UIKeyboardType.default
        
        editPasswordAlert.textFields![2].placeholder = "Re-enter your new password"
        editPasswordAlert.textFields![2].keyboardType = UIKeyboardType.default
        

        
        editPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in print("Canceled..")} ))
        
        editPasswordAlert.addAction(UIAlertAction(title: "Save", style: .default, handler:{(action) in
            
            let passwordText = editPasswordAlert.textFields![0].text
            self.myPhone.text = "********"
        } ))
        
        self.present(editPasswordAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.imageTap(gesture:)))
        chooseImage.addGestureRecognizer(tapImage)
        chooseImage.isUserInteractionEnabled = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func imageTap(gesture: UITapGestureRecognizer){
        if(gesture.view as? UIImageView) != nil {
            displayBottomSheet()
        }
    }
    
    func displayBottomSheet(){
       
                let optionsMenu = UIAlertController(title: "Action Required", message: "Add images via", preferredStyle: .actionSheet)
                let chooseCameraAction = UIAlertAction(title: "Camera", style: .default){
                    
                   _ in self.openCamera()}
                let choosePhotosAction = UIAlertAction(title: "Photos", style: .default){
                    _ in self.checkImagePermissions()
                    self.openPhotos()}
                let chooseCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
              
                optionsMenu.addAction(chooseCameraAction)
                optionsMenu.addAction(choosePhotosAction)
                optionsMenu.addAction(chooseCancelAction)
                self.present(optionsMenu, animated: true, completion: nil)
    }
    
    func checkImagePermissions(){
            if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
                PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) -> Void in ()
                })
            }
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
                //Nothing to do here
            }else{
                PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
            }
        }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
                print("AUTHORZIED")
            }else{
                print("NOT AUTHORZIED")
            }
        }
    
    func openCamera(){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
        
        
        
        
        //Mark: Image adding functions
        func openPhotos(){
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if imagePicker.sourceType == .camera{
                var cameraImage = UIImage()
                cameraImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
                
                
            }else{
                var galleryImage = UIImage()
                galleryImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                
                profileImageView.image =  galleryImage
                
            }
                    imagePicker.dismiss(animated: true, completion: nil)
        }


}
