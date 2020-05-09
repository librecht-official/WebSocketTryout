//
//  ViewWidget.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 05.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


class ViewWidget: UIView, NibOwnerLoadable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let view = Self.nib.instantiate(withOwner: self, options: nil).first! as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
