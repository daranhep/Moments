//
//  MediaTableViewCell.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import SAMCache

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var numberOfLikesButton: UIButton!
    @IBOutlet weak var viewAllCommentsButton: UIButton!
    
    var currentUser: User!
    var media: Media! {
        didSet {
            if currentUser != nil {
                self.updateUI()
            }
        }
    }
    
    var cache = SAMCache.shared()
    
    func updateUI()
    {
        self.mediaImageView.image = nil
        let mediaImageKey = "\(media.uid)-mediaImage"
        
        if let image = cache?.object(forKey: mediaImageKey) as? UIImage {
            self.mediaImageView.image = image
        } else {
            media.downloadMediaImage { [weak self] (image, error) in
                self?.mediaImageView.image = image
                self?.cache?.setObject(image, forKey: mediaImageKey)
            }
        }
        
        captionLabel.text = media.caption
        likeButton.setImage(UIImage(named: "icon-like"), for: [])
        
        if media.likes.count == 0 {
            numberOfLikesButton.setTitle("Be the first to like this!", for: [])
        } else {
            numberOfLikesButton.setTitle("♥️\(media.likes.count) likes", for: [])
            if media.likes.contains(currentUser) {
                likeButton.setImage(UIImage(named: "icon-like-filled"), for: [])
            }
        }
        
        if media.comments.count == 0 {
            viewAllCommentsButton.setTitle("Be the first to share a comment", for: [])
        } else {
            viewAllCommentsButton.setTitle("View all \(media.comments.count) comments", for: [])
        }
        
    }
    
    @IBAction func likeDidTap() {
        
    }
    
    @IBAction func commentDidTap() {
        
    }
    
    @IBAction func shareDidTap() {
        
    }
    
    @IBAction func numberOfLikesDidTap() {
        
    }
    
    @IBAction func viewAllCommentsDidTap() {
        
    }
    
    
    
}
