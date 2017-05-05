//
//  NewsFeedTableViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        struct Storyboard {
            static let showWelcome = "ShowWelcomeViewController"
        }
        
        // check if the user logged in or not
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                //signed in
            } else {
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })
    
    }

}
