//
//  ChatViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/18/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

/*
 
 1 - Send a text message - locally - x
 2 - Save message to Firebase - x
 3 - Download and observe messages - x
 4 - Fetch messages to ChatVC - x
 
 */

class ChatViewController: JSQMessagesViewController
{
    var chat: Chat!
    var currentUser: User!
    
    var messagesRef = DatabaseReference.messages.reference()
    
    var messages = [Message]()
    var jsqMessages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = chat.title
        self.setupBubbleImages()
        self.setupAvatarImages()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.observeMessages()
    }
    
    func back(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Avatar
    
    func setupBubbleImages()
    {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    func setupAvatarImages()
    {
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
}

// MARK: - JSQMessagesViewController DataSource

extension ChatViewController
{
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return jsqMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
}

// MARK: - Send Messages

extension ChatViewController
{
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        if chat.messageIds.count == 0 {
            chat.save()
            
            for account in chat.users {
                account.save(new: chat)
            }
        }
        
        let newMessage = Message(senderUID: currentUser.uid, senderDisplayName: currentUser.fullName, type: MessageType.text, text: text)
        newMessage.save()
        chat.send(message: newMessage)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
}

extension ChatViewController
{
    func observeMessages()
    {
        let chatMessageIdsRef = chat.ref.child("messageIds")
        chatMessageIdsRef.observe(.childAdded, with: { snapshot in
            let messageId = snapshot.value as! String
            DatabaseReference.messages.reference().child(messageId).observe(.value, with: { snapshot in
                let message = Message(dictionary: snapshot.value as! [String : Any])
                self.messages.append(message)
                self.add(message)
                self.finishReceivingMessage()
            })
        })
    }
    
    func add(_ message: Message)
    {
        if message.type == MessageType.text {
            let jsqMessage = JSQMessage(senderId: message.senderUID, displayName: message.senderDisplayName, text: message.text)
            jsqMessages.append(jsqMessage!)
        }
    }
}

