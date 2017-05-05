//
//  SignupTableViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class SignupTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var imagePickerHelper: ImagePickerHelper!
    var profileImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create New Account"
        
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true

    }

    @IBAction func createNewAccountDidTap() {
        
        // create a new account
        // save the user data, take a photo
        // login the user
        
        if emailTextField.text != ""
            && (passwordTextField.text?.characters.count)! > 6
            && (usernameTextField.text?.characters.count)! > 6
            && fullNameTextField.text != ""
            && profileImage != nil {
            
            let username = usernameTextField.text!
            let fullName = fullNameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firUser, error) in
                if error != nil {
                    //report error
                } else if let firUser = firUser {
                    let newUser = User(uid: firUser.uid, username: username, fullName: fullName, bio: "", website: "", follows: [], followedBy: [], profileImage: self.profileImage)
                    newUser.save(completion: { (error) in
                        if error != nil {
                            print(error)
                        } else {
                            // Login User
                            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                                if let error = error {
                                    print(error)
                                } else {
                                    self.dismiss(animated: true, completion: nil)
                                }
                            })
                        }
                    })
                }
            })
            
        }
        
    }
    
    @IBAction func backDidTap(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func changeProfilePhotoDidTap(_ sender: AnyObject) {
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
    }
}

extension SignupTableViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            createNewAccountDidTap()
        }
        
        return true
    }
}
