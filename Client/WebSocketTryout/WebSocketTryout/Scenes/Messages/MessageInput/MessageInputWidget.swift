//
//  MessageInputWidget.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 05.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


final class MessageInputWidget: ViewWidget {
    @IBOutlet private(set) var textView: UITextView!
    @IBOutlet private var placeholderLabel: UILabel!
    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var textViewHeight: NSLayoutConstraint!
    
    var onSend: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.textContainerInset.left = 8
        textView.textContainerInset.right = 8
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        updateUI()
        super.layoutSubviews()
        textView.layer.cornerRadius = 18
    }
    
    func clearText() {
        textView.text = ""
        updateUI()
    }
    
    @objc
    private func didTapSend() {
        onSend?(textView.text)
    }
    
    private func updateUI() {
        placeholderLabel.isHidden = !textView.text.isEmpty
        textViewHeight.constant = min(textView.contentSize.height, 300)
        sendButton.isEnabled = !textView.text.isEmpty
    }
}

extension MessageInputWidget: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateUI()
    }
}
