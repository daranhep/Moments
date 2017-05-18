//
//  ContactsPickerTableViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/18/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase
import VENTokenField

class ContactsPickerViewController: UITableViewController
{
    struct Storyboard {
        static let contactCell = "ContactCell"
        static let showChatViewController = "ShowChatViewController"
    }
    
    var chats: [Chat]!
    
    var accounts = [User]()
    var currentUser: User!
    
    var selectedAccounts = [User]()
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var contactsPickerField: VENTokenField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        title = "New Message"
        navigationItem.rightBarButtonItem = nextBarButtonItem
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Current user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBarController = appDelegate.window!.rootViewController as! UITabBarController
        let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
        let newsfeedTVC = firstNavVC.viewControllers.first as! NewsFeedTableViewController
        currentUser = newsfeedTVC.currentUser
        
        // Contacts Picker Field
        contactsPickerField.placeholderText = "Search..."
        contactsPickerField.setColorScheme(UIColor.red)
        contactsPickerField.delimiters = [",", ";", "--"]
        contactsPickerField.toLabelTextColor = UIColor.black
        contactsPickerField.dataSource = self
        contactsPickerField.delegate = self
        
        self.fetchUsers()
    }
    
    func fetchUsers()
    {
        let accountsRef = DatabaseReference.users(uid: currentUser.uid).reference().child("follows")
        accountsRef.observe(.childAdded, with: { snapshot in
            let user = User(dictionary: snapshot.value as! [String : Any])
            
            self.accounts.insert(user, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.contactCell, for: indexPath) as! ContactTableViewCell
        let user = accounts[indexPath.row]
        
        cell.user = user
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
        cell.added = !cell.added
        
        if cell.added == true {
            self.addRecipient(account: cell.user)
        } else {
            let index = selectedAccounts.index(of: cell.user)!
            self.deleteRecipient(account: cell.user, index: index)
        }
    }
    
    // MARK: - Helper Methods
    
    func addRecipient(account: User)
    {
        self.selectedAccounts.append(account)
        self.contactsPickerField.reloadData()
    }
    
    func deleteRecipient(account: User, index: Int)
    {
        selectedAccounts.remove(at: index)
        self.contactsPickerField.reloadData()
    }
    
    // MARK: - Chat
    
    @IBAction func nextDidTap()
    {
        var chatAccounts = selectedAccounts
        chatAccounts.append(currentUser)
        
        if let chat = findChat(among: chatAccounts) {
            self.performSegue(withIdentifier: Storyboard.showChatViewController, sender: chat)
        } else {
            var title = ""
            for acc in chatAccounts {
                if title == "" {
                    title += "\(acc.fullName)"
                } else {
                    title += ", \(acc.fullName)"
                }
            }
        }
        
        let newChat = Chat(users: chatAccounts, title: title!, featuredImageUID: chatAccounts.first!.uid)
        self.performSegue(withIdentifier: Storyboard.showChatViewController, sender: newChat)
    }
    
    func findChat(among chatAccounts: [User]) -> Chat?
    {
        if chats == nil { return nil }
        
        for chat in chats {
            var results = [Bool]()
            
            for acc in chatAccounts {
                let result = chat.users.contains(acc)
                results.append(result)
            }
            
            if !results.contains(false) {
                return chat
            }
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showChatViewController {
            let chat = sender as! Chat
            let chatVC = segue.destination as! ChatViewController
            chatVC.senderId = currentUser.uid
            chatVC.senderDisplayName = currentUser.fullName
            
            chatVC.chat = chat
            chatVC.currentUser = self.currentUser
            chatVC.hidesBottomBarWhenPushed = true
        }
    }
}

// MARK: - VENTokenFieldDataSource

extension ContactsPickerViewController : VENTokenFieldDataSource
{
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        return selectedAccounts[Int(index)].fullName
    }
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(selectedAccounts.count)
    }
}


// MARK: - VENTokenFieldDelegate

extension ContactsPickerViewController : VENTokenFieldDelegate
{
    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
        
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        let indexPath = IndexPath(row: Int(index), section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
        cell.added = !cell.added
        self.deleteRecipient(account: cell.user, index: Int(index))
    }
}
