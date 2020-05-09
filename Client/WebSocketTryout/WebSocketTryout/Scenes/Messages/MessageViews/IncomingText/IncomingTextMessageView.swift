//
//  IncomingTextMessageView.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


final class IncomingTextMessageView: UIView, NibLoadable {
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var senderLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 18
    }
    
    func configure(with message: TextMessage) {
        textLabel.text = message.text
        senderLabel.text = message.sender
    }
}

final class IncomingTextMessageCell: TableViewCell<IncomingTextMessageView> {
    override func commonInit() {
        super.commonInit()
        selectionStyle = .none
    }
    
    func configure(with message: TextMessage) {
        v.configure(with: message)
    }
    
    static func calcHeight(for message: TextMessage, tableView: UITableView) -> CGFloat {
        let bubbleContentSize = tableView.bounds.inset(by: tableView.layoutMargins).size
        
        let textHeight = message.text.height(
            withConstrainedWidth: bubbleContentSize.width - 92,
            font: UIFont.systemFont(ofSize: 17)
        )
        
        return textHeight + 37
    }
}
