//
//  CommentComposerViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/11/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit

class CommentComposerViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postBarButtonItem: UIBarButtonItem!
    
    var currentUser: User!
    var media: Media!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captionTextView.text = ""
        captionTextView.becomeFirstResponder()
        captionTextView.delegate = self
        
        if currentUser.profileImage == nil {
            profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
            currentUser.downloadProfilePicture(completion: { (image, error) in
                self.profileImageView.image = image
            })
        } else {
            profileImageView.image = currentUser.profileImage
        }
        
        usernameLabel.setTitle(currentUser.username, for: [])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.rightBarButtonItem = postBarButtonItem
        
    }
    
    // MARK: - Target / Action
    
    @IBAction func postDidTap(_ sender: AnyObject)
    {
        let comment = Comment(mediaUID: media.uid, from: currentUser, caption: captionTextView.text)
        comment.save()
        media.comments.append(comment)
        self.navigationController?.popViewController(animated: true)
    }

}

extension CommentComposerViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            postBarButtonItem.isEnabled = false
        } else {
            postBarButtonItem.isEnabled = true
        }
    }
}
