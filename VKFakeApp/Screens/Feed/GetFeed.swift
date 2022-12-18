//
//  GetFeed.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 30.06.2022.
//

import UIKit

final class GetFeed {
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }
    
    private let decoder = JSONDecoder()
    private let filters = "post, photo, wall_photo, friend"
    private let fields = "first_name, last_name, name"
    
    func feedGet(
        completion: @escaping(Result<[ResponseItems], Error>) -> Void)
    {
        guard let token = Session.instance.token else { return }
        
        var urlComponents = URLComponents()
        urlComponents.host = URLConfig.host.rawValue
        urlComponents.scheme = URLConfig.scheme.rawValue
        urlComponents.path = ApiMethods.getFeed.rawValue
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.131"),
            URLQueryItem(name: "filters", value: filters),
            URLQueryItem(name: "return_banned", value: "0"),
            URLQueryItem(name: "max_photos", value: "10"),
            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "fields", value: fields)
        ]
        
        guard let url = urlComponents.url else { return }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = HtttpMethods.get.rawValue
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
            }
            
            guard let data = data else {
                return
            }
            
            guard var feed = try? self.decoder.decode(FeedModel.self, from: data).response.items else { completion(.failure(error?.localizedDescription as! Error))
                return
            }
            
            guard let groups = try? self.decoder.decode(FeedModel.self, from: data).response.groups else {
                completion(.failure(error?.localizedDescription as! Error))
                return
            }
            
            for i in 0..<feed.count {
                let group = groups.first(where: { $0.id == -feed[i].sourceId })
                feed[i].avatar = group?.avatar
                feed[i].name = group?.name
                feed[i].screenName = group?.screenName
            }
            completion(.success(feed))
        }
        task.resume()
    }
}
