//
//  TableViewCell.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


class TableViewCell<View>: UITableViewCell, Reusable where View: UIView & NibLoadable {
    private(set) lazy var v = View.loadFromNib()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        contentView.addSubview(v)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        v.frame = contentView.bounds
    }
}
