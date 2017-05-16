//
//  Message.swift
//  Moments
//
//  Created by Dara Nhep on 5/16/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import Foundation
import Firebase

public struct MessageType {
    static let text = "text"
    static let image = "image"
    static let video = "video"
}

class Message
{
    var ref: FIRDatabaseReference
    var uid: String
    var senderDisplayName: String
    var senderUID: String
    var lastUpdate: Date
    var type: String
    var text: String
    
    init(senderUID: String, senderDisplayName: String, type: String, text: String)
    {
        ref = DatabaseReference.messages.reference().childByAutoId()
        uid = ref.key
        self.senderDisplayName = senderDisplayName
        self.senderUID = senderUID
        self.type = type
        self.lastUpdate = Date()
        self.text = text
    }
    
    init(dictionary: [String : Any])
    {
        uid = dictionary["uid"] as! String
        ref = DatabaseReference.messages.reference().child(uid)
        senderUID = dictionary["senderUID"] as! String
        senderDisplayName = dictionary["senderDisplayName"] as! String
        lastUpdate = Date(timeIntervalSince1970: dictionary["lastUpdate"] as! Double)
        type = dictionary["type"] as! String
        text = dictionary["text"] as! String
    }
    
    func save()
    {
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String : Any]
    {
        return [
            "uid" : uid,
            "senderDisplayName" : senderDisplayName,
            "lastUpdate" : lastUpdate.timeIntervalSince1970,
            "type" : type,
            "text" : text,
            "senderUID" : senderUID
        ]
    }
}

extension Message: Equatable { }

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.uid == rhs.uid
}
