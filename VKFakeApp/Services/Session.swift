//
//  Session.swift
//  VKFakeApp
//
//  Created by Алексей Артамонов on 28.05.2022.
//

import Foundation

final class Session {
    
    static let instance = Session()
    
    private init() {}
    
    var token: String?
    var id: Int?
}
