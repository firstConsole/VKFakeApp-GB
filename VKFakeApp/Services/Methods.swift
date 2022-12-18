//
//  Methods.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 28.05.2022.
//

import Foundation

enum ApiMethods: String {
    case getFriends = "/method/friends.get"
    case getGroups = "/method/groups.get"
    case getFeed = "/method/newsfeed.get"
    case getPhotos = "/method/photos.getAll"
}

enum HtttpMethods: String {
    case get = "GET"
    case post = "POST"
}

enum URLConfig: String {
    case scheme = "https"
    case host = "api.vk.com"
}

enum GetErrors: String, Error {
    case urlGetFail
    case failLoadData
    case parseFail
}
