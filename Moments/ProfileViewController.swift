//
//  ProfileViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logOutDidTap(_ sender: AnyObject)
    {
        try! FIRAuth.auth()?.signOut()
        self.tabBarController?.selectedIndex = 0
    }

}
