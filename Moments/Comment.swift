//
//  Comment.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class Comment {
    var mediaUID: String
    var uid: String
    var createdTime: Double
    var from: User
    var caption: String
    var ref: FIRDatabaseReference
    
    init(mediaUID: String, from: User, caption: String)
    {
        self.mediaUID = mediaUID
        self.from = from
        self.caption = caption
        
        self.createdTime = Date().timeIntervalSince1970
        
        ref = DatabaseReference.media.reference().child("\(mediaUID)/comments").childByAutoId()
        uid = ref.key
    }
    
    init(dictionary: [String : Any]) {
        uid = dictionary["uid"] as! String
        createdTime = dictionary["createdTime"] as! Double
        caption = dictionary["caption"] as! String
        
        let fromDictionary = dictionary["from"] as! [String : Any]
        from = User(dictionary: fromDictionary)
        
        mediaUID = dictionary["mediaUID"] as! String
        ref = DatabaseReference.media.reference().child("\(mediaUID)/comments/\(uid)")
    }
    
    func save() {
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String: Any]
    {
        return [
            "mediaUID" : mediaUID,
            "uid" : uid,
            "createdTime" : createdTime,
            "from" : from.toDictionary(),
            "caption" : caption
        ]
    }
    
}

extension Comment : Equatable { }

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.uid == rhs.uid
}
