//
//  Media.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class Media
{
    var uid: String
    let type: String
    var caption: String
    var createdTime: Double
    var createdBy: User
    var likes: [User]
    var comments: [Comment]
    var mediaImage: UIImage!
    
    init(type: String, caption: String, createdBy: User, image: UIImage)
    {
        self.type = type
        self.caption = caption
        self.createdBy = createdBy
        self.mediaImage = image
        
        createdTime = Date().timeIntervalSince1970
        comments = []
        likes = []
        uid = DatabaseReference.media.reference().childByAutoId().key
    }
    
    init(dictionary: [String : Any])
    {
        uid = dictionary["uid"] as! String
        type = dictionary["type"] as! String
        caption = dictionary["caption"] as! String
        createdTime = dictionary["createdTime"] as! Double
        
        let createdByDict = dictionary["createdBy"] as! [String : Any]
        createdBy = User(dictionary: createdByDict)
        
        likes = []
        if let likesDict = dictionary["likes"] as? [String : Any] {
            for (_, userDict) in likesDict {
                if let userDict = userDict as? [String : Any] {
                    likes.append(User(dictionary: userDict))
                }
            }
        }
        
        comments = []
    }
    
    func save(completion: @escaping (Error?) -> Void)
    {
        let ref = DatabaseReference.media.reference().child(uid)
        ref.setValue(toDictionary())
        
        // Save Likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        // Save Comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        
        // Upload image to storage database
        let firImage = FIRImage(image: mediaImage)
        firImage.save(self.uid, completion: { error in
            completion(error)
        })
        
    }
    
    func toDictionary() -> [String : Any]
    {
        return [
            "uid" : uid,
            "type" : type,
            "caption" : caption,
            "createdTime" : createdTime,
            "createdBy" : createdBy.toDictionary()
        ]
    }

}
extension Media {
    
    func downloadMediaImage(completion: @escaping (UIImage?, Error?) -> Void)
    {
        FIRImage.downloadImage(uid: uid, completion: { (image, error) in
            completion(image, error)
        })
    }
    
    class func observeNewMedia(_ completion: @escaping (Media) -> Void)
    {
        DatabaseReference.media.reference().observe(.childAdded, with: { snapshot in
            let media = Media(dictionary: snapshot.value as! [String: Any])
            completion(media)
        })
    }
    
    func observeNewComment(_ completion: @escaping (Comment) -> Void) {
        DatabaseReference.media.reference().child("\(uid)/comments").observe(.childAdded, with: { snapshot in
            let comment = Comment(dictionary: snapshot.value as! [String : Any])
            completion(comment)
        })
    }
    
    func likedBy(user: User) {
        self.likes.append(user)
        let ref = DatabaseReference.media.reference().child("\(uid)/likes/\(user.uid)")
        
        ref.setValue(user.toDictionary())
    }
    
    func unlikedBy(user: User) {
        if let index = likes.index(of: user) {
            likes.remove(at: index)
            let ref = DatabaseReference.media.reference().child("\(uid)/likes/\(user.uid)")
            
            ref.setValue(nil)
        }
    }
}

extension Media: Equatable { }

func ==(lhs: Media, rhs: Media) -> Bool {
    return lhs.uid == rhs.uid
}

