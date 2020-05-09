//
//  UIKitExt.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        layoutIfNeeded()
        let rect = CGRect(x: 0, y: contentSize.height - 1, width: 1, height: 1)
        scrollRectToVisible(rect, animated: animated)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }
}
