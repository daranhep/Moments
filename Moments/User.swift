//
//  User.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import Foundation
import Firebase

import Foundation
import Firebase

class User
{
    let uid: String
    var username: String
    var fullName: String
    var bio: String
    var website: String
    var profileImage: UIImage?
    
    var follows: [User]
    var followedBy: [User]
    
    // MARK: - Initializers
    
    init(uid: String, username: String, fullName: String, bio: String, website: String, follows: [User], followedBy: [User], profileImage: UIImage?)
    {
        self.uid = uid
        self.username = username
        self.fullName = fullName
        self.bio = bio
        self.website = website
        self.follows = follows
        self.followedBy = followedBy
        self.profileImage = profileImage
    }
    
    init(dictionary: [String : Any])
    {
        uid = dictionary["uid"] as! String
        username = dictionary["username"] as! String
        fullName = dictionary["fullName"] as! String
        bio = dictionary["bio"] as! String
        website = dictionary["website"] as! String
        
        // follows
        self.follows = []
        if let followsDict = dictionary["follows"] as? [String : Any] {
            for (_, userDict) in followsDict {
                if let userDict = userDict as? [String : Any] {
                    self.follows.append(User(dictionary: userDict))
                }
            }
        }
        
        // followedBy
        followedBy = []
        if let followedByDict = dictionary["followedBy"] as? [String : Any] {
            for (_, userDict) in followedByDict {
                if let userDict = userDict as? [String : Any] {
                    self.followedBy.append(User(dictionary: userDict))
                }
            }
        }
    }
    
    func save(completion: @escaping (Error?) -> Void)
    {
        // 1
        let ref = DatabaseReference.users(uid: uid).reference()
        ref.setValue(toDictionary())
        
        // 2 - save follows
        for user in follows {
            ref.child("follows/\(user.uid)").setValue(user.toDictionary())
        }
        
        // 3 - save followed by "followedBy"
        for user in followedBy {
            ref.child("followedBy/\(user.uid)").setValue(user.toDictionary())
        }
        
        // 4 - save the profile image
        if let profileImage = self.profileImage {
            let firImage = FIRImage(image: profileImage)
            firImage.saveProfileImage(self.uid, { (error) in
                completion(error)
            })
        }
    }
    
    func toDictionary() -> [String : Any] {
        return [
            "uid" : uid,
            "username" : username,
            "fullName" : fullName,
            "bio" : bio,
            "website" : website
        ]
    }
}

extension User {
    func share(newMedia: Media) {
        DatabaseReference.users(uid: uid).reference().child("media").childByAutoId().setValue(newMedia.uid)
    }
    
    func downloadProfilePicture(completion: @escaping (UIImage?, NSError?) -> Void)
    {
        FIRImage.downloadProfileImage(uid, completion: { (image, error) in
            self.profileImage = image
            completion(image, error as NSError?)
        })
    }
    
    func follow(user: User) {
        self.follows.append(user)
        let ref = DatabaseReference.users(uid: uid).reference().child("follows/\(user.uid)")
        
        ref.setValue(user.toDictionary())
    }
    
    func isFollowedBy(_ user: User) {
        self.followedBy.append(user)
        let ref = DatabaseReference.users(uid: uid).reference()
        ref.child("followedBy/\(user.uid)").setValue(user.toDictionary())
    }
    
    func save(new chat: Chat)
    {
        DatabaseReference.users(uid: self.uid).reference().child("chatIds/\(chat.uid)").setValue(true)
    }

}

extension User: Equatable { }

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}
