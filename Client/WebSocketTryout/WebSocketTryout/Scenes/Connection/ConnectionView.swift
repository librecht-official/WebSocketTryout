//
//  ConnectionView.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


final class ConnectionViewController: NibViewController<ConnectionView> {
    let env: Environment
    let onConnect: (String) -> ()
    
    init(env: Environment, onConnect: @escaping (String) -> ()) {
        self.env = env
        self.onConnect = onConnect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Connect"
        
        v.connectButton.addTarget(self, action: #selector(connect), for: .touchUpInside)
    }
    
    @objc
    private func connect(_ sender: UIButton) {
        let username = v.usernameTextField.text.orEmpty
        if username.isEmpty {
            return
        }
        env.saveConnectedUser(User(username: username))
        onConnect(username)
    }
}

// MARK: -

final class ConnectionView: UIView, NibLoadable {
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var connectButton: UIButton!
}
