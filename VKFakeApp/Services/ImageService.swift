//
//  ImageService.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 04.06.2022.
//

import Foundation
import UIKit

private var images = [String: UIImage]()

final class ImageLoadService {
    private let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    func imageLoad(url: URL, completion: @escaping(Result<Data, Error>) -> Void) {
        let completionOnMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        session.dataTask(with: url) { data, response, error in
            guard let responseData = data, error == nil else {
                if let error = error {
                    completionOnMain(.failure(error))
                    print(error)
                }
                return
            }
            completionOnMain(.success(responseData))
        }.resume()
    }
    
    func loadImage(url: String, completion: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        ImageLoadService().imageLoad(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func imageFilter(
        by sizeType: Sizes.SizeType,
        from array: [Photo]) -> [String] {
            
            var links: [String] = []
            
            for model in array {
                for size in model.sizes {
                    if size.type == sizeType {
                        links.append(size.url!)
                    }
                }
            }
            return links
        }
}

