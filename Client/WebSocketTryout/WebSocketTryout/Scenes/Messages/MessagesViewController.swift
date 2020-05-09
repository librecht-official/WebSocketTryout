//
//  ViewController.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 04.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit
import AVFoundation


final class MessagesViewController: NibViewController<MessagesView> {
    let model: MessagesModel
    let onDisconnect: () -> ()
    
    private lazy var logoutButton = UIBarButtonItem(
        title: "Disconnect",
        style: .done,
        target: self,
        action: #selector(disconnect)
    )
    
    init(model: MessagesModel, onDisconnect: @escaping () -> ()) {
        self.model = model
        self.onDisconnect = onDisconnect
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Messages"
        navigationItem.leftBarButtonItem = logoutButton
        
        v.tableView.dataSource = self
        v.tableView.delegate = self
        v.tableView.separatorColor = UIColor.clear
        v.tableView.separatorStyle = .none
        v.tableView.separatorInset.left = 1000
        
        setupKeyboardObservers()
        
        v.messageInput.onSend = { [weak self] text in
            self?.model.send(textMessage: text)
            self?.v.messageInput.clearText()
        }
        
        model.onMessagesUpdated = { [weak self] _ in
            self?.v.tableView.reloadData()
            DispatchQueue.main.async {
                self?.v.tableView.scrollToBottom(animated: true)
            }
        }
        model.onNewMessageReceived = { (model, message) in
            if model.isIncoming(message: message) {
                AudioServicesPlaySystemSound(1003)
            } else {
                AudioServicesPlaySystemSound(1004)
            }
        }
    }
    
    @objc
    private func disconnect() {
        model.disconnect()
        onDisconnect()
    }
    
    // MARK: Keyboard
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(adjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc
    private func adjustForKeyboard(_ notification: Notification) {
        let dict = notification.userInfo
        guard let keyboardValue = dict?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = dict?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            v.bottom.constant = 0
        } else {
            v.bottom.constant = -(keyboardViewEndFrame.height - view.safeAreaInsets.bottom)
            v.tableView.contentOffset.y += (keyboardViewEndFrame.height - view.safeAreaInsets.bottom)
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = model.messages[indexPath.row]
        if model.isIncoming(message: message) {
            let cell = tableView.dequeueReusableCell(
                for: indexPath, cellType: IncomingTextMessageCell.self
            )
            cell.configure(with: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(
                for: indexPath, cellType: OutgoingTextMessageCell.self
            )
            cell.configure(with: message)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension MessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRow(at: indexPath, tableView)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        heightForRow(at: indexPath, tableView)
    }
    
    private func heightForRow(at indexPath: IndexPath, _ tableView: UITableView) -> CGFloat {
        let message = model.messages[indexPath.row]
        if model.isIncoming(message: message) {
            return IncomingTextMessageCell.calcHeight(for: message, tableView: tableView)
        } else {
            return OutgoingTextMessageCell.calcHeight(for: message, tableView: tableView)
        }
    }
}

// MARK: -

final class MessagesView: UIView, NibLoadable {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var messageInput: MessageInputWidget!
    @IBOutlet var bottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.contentInset.top = 16
        tableView.contentInset.bottom = 16
        tableView.register(cellType: IncomingTextMessageCell.self)
        tableView.register(cellType: OutgoingTextMessageCell.self)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnTableView))
        tableView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func didTapOnTableView() {
        self.endEditing(true)
    }
}
