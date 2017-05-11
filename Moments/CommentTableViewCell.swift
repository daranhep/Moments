//
//  CommentTableViewCell.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    var comment: Comment! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        profileImageView.image = UIImage(named: "icon-defaultAvatar")
        comment.from.downloadProfilePicture { [weak self] (image, error) in
            self?.profileImageView.image = image
        }
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        usernameButton.setTitle(comment.from.username, for: [])
        commentTextLabel.text = comment.caption
        
    }
    
    
}
