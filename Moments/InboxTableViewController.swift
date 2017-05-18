//
//  InboxTableViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/18/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class InboxTableViewController: UITableViewController {
    
    struct Storyboard {
        static let chatCell = "ChatCell"
        static let segueShowChatViewController = "ShowChatViewController"
        static let segueShowContactsViewController = "ShowContactsViewController"
    }
    
    
    // MARK: - PROPERTIES
    
    var chats: [Chat] = []
    
    var currentUser: User!
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setCurrentUser()
        
        self.fetchChats()
    }
    
    // MARK: - HELPER METHODS
    
    func setCurrentUser() {
        
        // THIS CAN BE USED INSTEAD: appDelegate.window!.rootViewController
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        let firstNavVC = tabBarController.viewControllers?.first as! UINavigationController
        
        let newsFeedTVC = firstNavVC.topViewController as! NewsFeedTableViewController
        
        self.currentUser = newsFeedTVC.currentUser
        
        
    }
    
    func fetchChats() {
        
        let userChatIdsRef = DatabaseReference.users(uid: currentUser.uid).reference().child("chatIds")
        
        userChatIdsRef.observe(.childAdded, with: { (snapshot) in
            
            let chatId = snapshot.key
            
            DatabaseReference.chats.reference().child(chatId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let chat = Chat(dictionary: snapshot.value as! [String: Any])
                
                
                if !self.alreadyAddedChat(chat) {
                    // ADDING NEW CELL WITH NEW CHAT
                    
                    self.chats.append(chat)
                    
                    let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                    
                } else {
                    
                    self.tableView.reloadData()
                    
                    // UPDATING CELL WITH EXISTING CHAT
                    //                    if let index = self.chats.index(of: chat) {
                    //
                    //                        let cellToUpdate = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! ChatTableViewCell
                    //
                    //                        cellToUpdate.chat = chat
                    //                    }
                    
                }
                
            })
            
        })
        
        
        
    }
    
    
    func alreadyAddedChat(_ chat: Chat) -> Bool {
        for c in self.chats {
            if c.uid == chat.uid {
                return true
            }
        }
        return false
    }
    
    func userSignedOut() {
        self.currentUser = nil
        self.chats.removeAll()
        self.tableView.reloadData()
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.segueShowChatViewController {
            
            let chat = sender as! Chat
            
            let chatVC = segue.destination as! ChatViewController
            
            chatVC.senderId = currentUser.uid
            chatVC.senderDisplayName = currentUser.fullName
            
            chatVC.chat = chat
            chatVC.currentUser = self.currentUser
            
            chatVC.hidesBottomBarWhenPushed = true
            
            
        } else if segue.identifier == Storyboard.segueShowContactsViewController {
            
            let contactsVC = segue.destination as! ContactsPickerViewController
            
            contactsVC.currentUser = self.currentUser
            contactsVC.chats = self.chats
            
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.chatCell, for: indexPath) as! ChatTableViewCell
        
        let chat = chats[indexPath.row]
        
        cell.chat = chat
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        let selectedCell = tableView.cellForRow(at: indexPath)
        
        let selectedChat = chats[indexPath.row]
        
        performSegue(withIdentifier: Storyboard.segueShowChatViewController, sender: selectedChat)
    }
    
}
