//
//  AppEnvironment.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import Foundation


protocol Environment {
    func makeWebSocketManager() -> WebSocketManagerType
    func userConnectionStatus() -> UserConnectionStatus
    func saveConnectedUser(_ user: User)
    func discardConnectedUser()
}

final class AppEnvironment: Environment {
    func makeWebSocketManager() -> WebSocketManagerType {
        return WebSocketManager(
            config: WebSocketManager.Config(
                url: URL(string: "ws://192.168.0.3:80")!,
                log: { print($0) }
            )
        )
    }
    
    func userConnectionStatus() -> UserConnectionStatus {
        if let username = UserDefaults.standard.string(forKey: k.username) {
            return .connected(User(username: username))
        } else {
            return .notConnected
        }
    }
    
    func saveConnectedUser(_ user: User) {
        UserDefaults.standard.set(user.username, forKey: k.username)
        UserDefaults.standard.synchronize()
    }
    
    func discardConnectedUser() {
        UserDefaults.standard.removeObject(forKey: k.username)
        UserDefaults.standard.synchronize()
    }
}

private enum k {
    static let username = "App.Username"
}
