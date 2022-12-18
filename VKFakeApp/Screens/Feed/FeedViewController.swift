//
//  FeedViewController.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 28.05.2022.
//

import UIKit
import PromiseKit

final class FeedViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let getFeed = GetFeed()
    let imageService = ImageLoadService()
    var responseItems: [ResponseItems] = []
    
    private var photoService: PhotoService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        photoService = PhotoService(container: tableView)
        tableViewCellsRegister()
        loadFeed()
    }
}
