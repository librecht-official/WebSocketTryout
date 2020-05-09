//
//  OutgoingTextMessageCell.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 05.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


final class OutgoingTextMessageView: UIView, NibLoadable {
    @IBOutlet var bubbleView: UIView!
    @IBOutlet var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleView.layer.cornerRadius = 18
    }
    
    func configure(with message: TextMessage) {
        textLabel.text = message.text
    }
}

final class OutgoingTextMessageCell: TableViewCell<OutgoingTextMessageView> {
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
        
        return textHeight + 24
    }
}
