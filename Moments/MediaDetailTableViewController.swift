//
//  MediaDetailTableViewController.swift
//  Moments
//
//  Created by Dara Nhep on 5/11/17.
//  Copyright © 2017 Dara Nhep. All rights reserved.
//

import UIKit
import Firebase

class MediaDetailTableViewController: UITableViewController
{
    var media: Media!
    var currentUser: User!
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Photo"
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = Storyboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        comments = media.comments
        tableView.reloadData()
        
//        self.fetchComments()
    }
    
//    func fetchComments()
//    {
//        media.observeNewComment { (comment) in
//            if !self.comments.contains(comment) {
//                self.comments.insert(comment, at: 0)
//                self.tableView.reloadData()
//            }
//        }
//    }
//    
//    // MARK: - Target / Action
//    
//    @IBAction func commentDidTap() {
//        self.performSegue(withIdentifier: Storyboard.showCommentComposer, sender: media)
//    }
//    
//    // MARK: - Navigation
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Storyboard.showCommentComposer {
//            let commentComposer = segue.destination as! CommentComposerViewController
//            commentComposer.media = media
//            commentComposer.currentUser = currentUser
//        }
//    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            // Media row
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaTableViewCell
            
            cell.currentUser = currentUser
            cell.media = media
            
            
            return cell
        } else {
            // Comment row
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.commentCell, for: indexPath) as! CommentTableViewCell
            
            cell.comment = comments[indexPath.row - 1]
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = media
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }
}
