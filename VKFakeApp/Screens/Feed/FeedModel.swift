//
//  FeedModel.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 28.05.2022.
//

import Foundation

//MARK: - FeedModels

struct FeedModel: Codable {
    let response: FeedResponse
}

struct FeedResponse: Codable {
    let items: [ResponseItems]
    let groups: [ResponseGroups]
    let nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items
        case groups
        case nextFrom = "next_from"
    }
}

//MARK: - ResponseItems

struct ResponseItems: Codable {
    let postId: Int?
    let text: String?
    let date: Double?
    let postType: String?
    let attachments: [Attachments]?
    let likes: Likes?
    let comments: Comments?
    let reposts: Reposts?
    var sourceId: Int
    var avatar: String?
    var name: String?
    var screenName: String?
    var photoURL: [String]? {
        get {
            let url = attachments?.compactMap{ $0.photo?.sizes.last?.url }
            return url
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case text
        case date
        case postType = "post_type"
        case attachments
        case likes
        case comments
        case reposts
        case sourceId = "source_id"
        case avatar
        case name
        case screenName
    }
}

struct Attachments: Codable {
    let type: String?
    let photo: Photo?
}

struct Likes: Codable {
    let count: Int?
}

struct Comments: Codable {
    let count: Int?
}

struct Reposts: Codable {
    let count: Int?
}

struct Photo: Codable {
    let id: Int?
    let ownerId: Int?
    let sizes: [Sizes]
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sizes
    }
}

struct Sizes: Codable {
    let type: SizeType?
    let url: String?
    
    enum SizeType: String, Codable {
        case a = "a"
        case b = "b"
        case c = "c"
        case d = "d"
        case e = "e"
        case k = "k"
        case l = "l"
        case m = "m"
        case o = "o"
        case p = "p"
        case q = "q"
        case r = "r"
        case s = "s"
        case w = "w"
        case x = "x"
        case y = "y"
        case z = "z"
    }
}

// MARK: - ResponseGroups

struct ResponseGroups: Codable {
    var id: Int
    var name: String
    var screenName: String
    var type: String
    var avatar: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case type
        case avatar = "photo_200"
    }
}
