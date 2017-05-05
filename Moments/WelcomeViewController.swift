//
//  WelcomeViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/5/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.dismiss(animated: false, completion: nil)
            } else {
                
            }
        })
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
