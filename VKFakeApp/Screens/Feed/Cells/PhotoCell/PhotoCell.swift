//
//  PhotoCell.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 02.06.2022.
//

import UIKit

final class PhotoCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    
    static let identifier = "PhotoCell"
    
    override func prepareForReuse() {
        photo.image = nil
    }
    
    func configureCell(with image: UIImage) {
        photo.image = image
    }
    
    func configureImage(with image: UIImage?) {
        photo.image = image
    }
}
