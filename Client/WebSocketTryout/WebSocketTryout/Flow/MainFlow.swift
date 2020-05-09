//
//  Flow.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


func runMainFlow(env: Environment, navigator: MainNavigator) {
    weak var navigator = navigator
    
    func openConnectionScreen() {
        let vc = ConnectionViewController(env: env) { username in
            openMessages(user: User(username: username))
        }
        navigator?.setViewControllers([vc], animated: true)
    }
    
    func openMessages(user: User) {
        let model = MessagesModel(user: user, env: env)
        let vc = MessagesViewController(model: model) {
            openConnectionScreen()
        }
        navigator?.setViewControllers([vc], animated: true)
    }
    
    switch env.userConnectionStatus() {
    case .notConnected:
        openConnectionScreen()
    
    case let .connected(user):
        openMessages(user: user)
    }
}

protocol MainNavigator: AnyObject {
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}

extension UINavigationController: MainNavigator {}
