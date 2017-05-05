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
    
    struct Storyboard {
        static let showWelcome = "ShowWelcomeViewController"
        static let postComposerNVC = "PostComposerNavigationVC"
    }
    
    var imagePickerHelper: ImagePickerHelper!
    var currentUser: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // check if the user logged in or not
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                DatabaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any]
                    {
                        self.currentUser = User(dictionary: userDict)
                    }
                })
            } else {
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })
        
        self.tabBarController?.delegate = self
    
    }

}

extension NewsFeedTableViewController : UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewController as? DummyPostComposerViewController
        {
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.postComposerNVC) as! UINavigationController
                let postComposerVC = postComposerNVC.topViewController as! PostComposerViewController
                
                postComposerVC.image = image
                
                self.present(postComposerNVC, animated: true, completion: nil)
            })
            
            return false
        }
        
        return true
    }
}
