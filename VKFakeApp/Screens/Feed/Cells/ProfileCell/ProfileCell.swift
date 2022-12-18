//
//  ProfileCell.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 01.06.2022.
//

import UIKit

final class ProfileCell: UITableViewHeaderFooterView {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileStatus: UILabel!
    
    static let identifier = "ProfileCell"
    
    private let imageService = ImageLoadService()
    
    func configureCell(
        image: String?,
        name: String?,
        screenName: String?)
    {
        DispatchQueue.main.async {
            self.profileStatus.text = screenName
            self.profileName.text = name
            self.profileImage.image = UIImage(named: "user")
            
            self.profileImage.layer.shadowColor = UIColor.black.cgColor
            self.profileImage.layer.shadowOpacity = 0.4
            self.profileImage.layer.shadowOffset = CGSize.zero
            self.profileImage.layer.shadowRadius = 10
            self.profileImage.layer.shadowPath = UIBezierPath(rect: self.profileImage.bounds).cgPath
            self.profileImage.layer.shouldRasterize = false
            self.profileImage.layer.cornerRadius = 20
            self.profileImage.clipsToBounds = true
        }
        
        
        if let url = image {
            imageService.loadImage(url: url) { image in
                self.profileImage.image = image
                DispatchQueue.main.async {
                    self.reloadInputViews()
                }
            }
        }
    }
    
}

