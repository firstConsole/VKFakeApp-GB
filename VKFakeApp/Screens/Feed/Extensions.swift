//
//  Extensions.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 13.06.2022.
//

import UIKit

//MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return responseItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let photoCell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier)
                    as? PhotoCell
            else {
                return UITableViewCell()
            }
            
            guard let photoUrl = responseItems[indexPath.section].photoURL?.first else {
                return UITableViewCell()
            }
            
//            let photoService: PhotoService?
//
//            photoService = PhotoService(container: tableView)
//
//            guard let photo = photoService?.photo(atIndexPath: indexPath,
//                                                  byUrl: photoUrl) else { return UITableViewCell() }
            
            DispatchQueue.main.async {
                self.imageService.loadImage(url: photoUrl) { photo in
                    photoCell.configureImage(with: photo)
                }
                
            }
            
            
            return photoCell
        case 1:
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier)
                    as? TextCell
            else {
                return UITableViewCell()
            }
            
            guard let text = responseItems[indexPath.section].text else { return UITableViewCell() }
            
            DispatchQueue.main.async {
                textCell.configureCell(with: text)
            }
            
            return textCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let profileCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileCell.identifier)
                as? ProfileCell
        else {
            return UITableViewCell()
        }
        
        let screenName = responseItems[section].screenName
        let name = responseItems[section].name
        let image = responseItems[section].avatar
        
        DispatchQueue.main.async {
            profileCell.configureCell(image: image,
                                      name: name,
                                      screenName: screenName)
        }
        
        return profileCell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let activityCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ActivityCell.identifier)
                as? ActivityCell
        else {
            return UITableViewCell()
        }
        
        let likes = responseItems[section].likes?.count?.description
        let reposts = responseItems[section].reposts?.count?.description
        let comments = responseItems[section].comments?.count?.description
        
        DispatchQueue.main.async {
            activityCell.configureCell(likes: likes,
                                       reposts: reposts,
                                       comments: comments)
        }

        return activityCell
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Метод регистрации ячеек TableView

extension FeedViewController {
    
    func tableViewCellsRegister() {
        
        DispatchQueue.main.async {
            self.tableView.estimatedRowHeight = 44.0
            self.tableView.rowHeight = UITableView.automaticDimension
            
            self.tableView.register(UINib(nibName: "ProfileCell", bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: ProfileCell.identifier)
            
            self.tableView.register(UINib(nibName: "PhotoCell",
                                          bundle: nil),
                                    forCellReuseIdentifier: PhotoCell.identifier)
            self.tableView.register(UINib(nibName: "TextCell",
                                          bundle: nil),
                                    forCellReuseIdentifier: TextCell.identifier)
            
            self.tableView.register(UINib(nibName: "ActivityCell", bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: ActivityCell.identifier)
        }
    }
}


// MARK: - Методы для обработки JSON

extension FeedViewController {

    func loadFeed() {
        getFeed.feedGet { result in
            switch result {
                
            case .success(let feed):
                self.responseItems = feed
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

