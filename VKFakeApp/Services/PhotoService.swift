//
//  PhotoService.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 26.06.2022.
//

import Foundation
import Alamofire
import UIKit
import SwiftUI

final class PhotoService {
    
    private var images = [String: UIImage]()
    
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    
    private static let path: String = {
        let path = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory,
                                                             in: .userDomainMask).first else {
            return path
        }
        
        let url = cachesDirectory.appendingPathComponent(path, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        
        return path
    }()
    
    func photo(atIndexPath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        
        print(url)
        
        if let photo = images[url] {
            image = photo
        } else if let photo = getFromCache(with: url) {
            image = photo
        } else {
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        return image
    }
    
    private func getFromCache(with url: String) -> UIImage? {
        guard
            let file = getPath(with: url),
            let info = try? FileManager.default.attributesOfItem(atPath: file),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
        else {
            return nil
        }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard
            lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: file)
        else {
            return nil
        }
        
        DispatchQueue.main.async {
            self.images[url] = image
        }
        return image
    }
    
    private func getPath(with url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hash = url.split(separator: "/").last ?? "default"
        
        return cachesDirectory.appendingPathComponent(PhotoService.path + "/" + hash).path
    }
    
    private func loadPhoto(atIndexPath indexPath: IndexPath,
                           byUrl url: String) {
        AF.request(url).responseData(queue: .global()) { [weak self] result in
            guard
                let self = self,
                let data = result.data,
                let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.images[url] = image
            }
            
            self.saveImageToCache(url: url, image: image)
            
            DispatchQueue.main.async {
                self.container.reloadRow(atIndexPath: indexPath)
            }
        }
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard
            let file = getPath(with: url),
            let data = image.pngData() else {
            return
        }
        
        print(file)
        FileManager.default.createFile(atPath: file,
                                       contents: data,
                                       attributes: nil)
    }
}

fileprivate protocol DataReloadable {
    func reloadRow(atIndexPath indexPath: IndexPath)
}

extension PhotoService {
    private class Table: DataReloadable {
        func reloadRow(atIndexPath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
    }
}
