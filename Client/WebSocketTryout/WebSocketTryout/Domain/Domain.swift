//
//  Domain.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import Foundation


struct TextMessage: Equatable, Identifiable {
    let id: String
    let date: Date
    let sender: String
    let text: String
    
    init?(dict: [String: Any]) {
        guard
            let id = dict["id"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval,
            let sender = dict["sender"] as? String,
            let text = dict["text"] as? String else {
            return nil
        }
        self.id = id
        self.date = Date(timeIntervalSince1970: timestamp)
        self.sender = sender
        self.text = text
    }
}

struct User: Equatable {
    let username: String
}

enum UserConnectionStatus: Equatable {
    case connected(User)
    case notConnected
}
