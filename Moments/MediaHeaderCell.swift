//
//  MediaHeaderCell.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit

class MediaHeaderCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var currentUser: User!
    var media: Media! {
        didSet {
            if currentUser != nil {
                self.updateUI()
            }
        }
    }
    
    func updateUI()
    {
        media.createdBy.downloadProfilePicture { [weak self] (image, error) in
            if let image = image {
                self?.profileImageView.image = image
            } else if error != nil {
                print(error)
            }
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        usernameButton.setTitle(media.createdBy.username, for: [])
        
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.layer.masksToBounds = true
        if currentUser.follows.contains(media.createdBy) || media.createdBy.uid == currentUser.uid {
            followButton.isHidden = true
        } else {
            followButton.isHidden = false
        }
    }
    

}
