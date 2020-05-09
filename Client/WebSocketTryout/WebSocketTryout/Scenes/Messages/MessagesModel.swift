//
//  MessagesModel.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 05.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import Foundation


final class MessagesModel {
    let env: Environment
    let user: User
    let wsManager: WebSocketManagerType
    var onMessagesUpdated: ((MessagesModel) -> ())? {
        didSet { onMessagesUpdated?(self) }
    }
    var onNewMessageReceived: ((MessagesModel, TextMessage) -> ())?
    
    private(set) var messages: [TextMessage] = []
    
    init(user: User, env: Environment) {
        let wsManager = env.makeWebSocketManager()
        self.env = env
        self.user = user
        self.wsManager = wsManager
        
        wsManager.onOpen = { [weak self] in
            self?.wsManager.send(user.username) { error in
                if let error = error {
                    print("Sending username failed: \(error)")
                }
            }
        }
        wsManager.onReceive = { [weak self] data in
            self?.handle(data: data)
        }
        
        wsManager.connect()
    }
    
    func handle(data: Data) {
        do {
            let any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let json = any as? [String: Any] else {
                print("Failed to deserialize data to JSON")
                return
            }
            guard let type = json["type"] as? String else {
                print("Unknown response format (type)")
                return
            }
            switch type {
            case "message": handleMessage(json: json)
            case "history": handleHistory(json: json)
            default: return
            }
        } catch {
            print(error)
        }
    }
    
    private func handleMessage(json: [String : Any]) {
        guard let dict = json["data"] as? [String: Any] else {
            print("Unknown message data")
            return
        }
        if let message = TextMessage(dict: dict) {
            messages.append(message)
            notifyUpdates()
            onNewMessageReceived?(self, message)
        }
    }
    
    private func handleHistory(json: [String : Any]) {
        guard let array = json["data"] as? [[String: Any]] else {
            print("Unknown history data")
            return
        }
        let history = array.compactMap(TextMessage.init(dict:))
        messages.merge(history)
        notifyUpdates()
    }
    
    func send(textMessage: String) {
        wsManager.send(textMessage, completionHandler: { error in
            if let error = error {
                print("Failed to send textMessage: \(error)")
            }
        })
    }
    
    func isIncoming(message: TextMessage) -> Bool {
        message.sender != user.username
    }
    
    func disconnect() {
        wsManager.close()
        env.discardConnectedUser()
    }
    
    private func notifyUpdates() {
        DispatchQueue.main.async {
            self.onMessagesUpdated?(self)
        }
    }
}
