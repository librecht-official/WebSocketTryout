//
//  WebSocketManager.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 04.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import Foundation


protocol WebSocketManagerType: AnyObject {
    var onOpen: (() -> Void)? { get set }
    var onReceive: ((Data) -> Void)? { get set }
    
    func connect()
    func send(_ string: String, completionHandler: @escaping (Error?) -> Void)
    func send(_ data: Data, completionHandler: @escaping (Error?) -> Void)
    func close()
}

final class WebSocketManager: NSObject, WebSocketManagerType {
    struct Config {
        let url: URL
        let log: ((Any) -> Void)?
    }
    
    var onOpen: (() -> Void)?
    var onReceive: ((Data) -> Void)?
    
    private let config: Config
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        return URLSession(
            configuration: config, delegate: self, delegateQueue: nil
        )
    }()
    private var webSocketTask: URLSessionWebSocketTask?
    private var reconnectTimer: Timer?
    
    init(config: Config) {
        self.config = config
        super.init()
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    func connect() {
        let request = URLRequest(url: config.url)
        self.webSocketTask = session.webSocketTask(with: request)
        self.webSocketTask?.resume()
        self.receiveNext()
    }
    
    func send(_ string: String, completionHandler: @escaping (Error?) -> Void) {
        webSocketTask?.send(.string(string), completionHandler: completionHandler)
    }
    
    func send(_ data: Data, completionHandler: @escaping (Error?) -> Void) {
        webSocketTask?.send(.data(data), completionHandler: completionHandler)
    }
    
    func close() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        session.finishTasksAndInvalidate()
    }
    
    private func receiveNext() {
        webSocketTask?.receive(completionHandler: { [weak self] result in
            guard let this = self else { return }
            if this.handle(result: result) {
                this.receiveNext()
            }
        })
    }
    
    private func handle(result: Result<URLSessionWebSocketTask.Message, Error>) -> Bool {
        switch result {
        case let .success(.string(string)):
            let data = string.data(using: .utf8)!
            config.log?("Did receive data: \(data)")
            onReceive?(data)
            
        case let .success(.data(data)):
            config.log?("Did receive data: \(data)")
            onReceive?(data)
            
        case let .failure(error):
            config.log?("Did receive error: \(error)")
            scheduleReconnect()
            return false
        
        case .success:
            break
        }
        
        return true
    }
    
    private func scheduleReconnect() {
        DispatchQueue.main.async {
            self.reconnectTimer = Timer.scheduledTimer(
                withTimeInterval: 3, repeats: false, block: { [weak self] _ in
                    self?.config.log?("Trying to reconnect...")
                    self?.connect()
            })
        }
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?) {
        
        config.log?("Did open WS connection")
        reconnectTimer?.invalidate()
        reconnectTimer = nil
        onOpen?()
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?) {
        
        config.log?("Did close WS connection with code: \(closeCode)")
    }
}
