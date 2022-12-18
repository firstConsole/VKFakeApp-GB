//
//  ActivityCell.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 02.06.2022.
//

import UIKit

final class ActivityCell: UITableViewHeaderFooterView {

    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    static let identifier = "ActivityCell"
    
    func configureCell(
        likes: String?,
        reposts: String?,
        comments: String?)
    {
        likesLabel.text = likes
        repostsLabel.text = reposts
        commentsLabel.text = comments
    }
    
    
    @IBAction func likeButton(_ sender: UIButton) {
        
    }
    
    @IBAction func repostButton(_ sender: UIButton) {
        
    }
    
    @IBAction func commentButton(_ sender: UIButton) {
        
    }
}
