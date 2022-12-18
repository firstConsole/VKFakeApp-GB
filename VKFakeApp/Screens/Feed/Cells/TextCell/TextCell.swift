//
//  TextCell.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 01.06.2022.
//

import UIKit

final class TextCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var textPlaceView: UITextView!
    
    static let identifier = "TextCell"
    
    func configureCell(with text: String) {
        textPlaceView.text = text
    }
}
