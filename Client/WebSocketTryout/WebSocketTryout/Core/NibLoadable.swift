//
//  NibLoadable.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 05.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit

// MARK: - NibLoadable

protocol NibLoadable: AnyObject {
    static func loadFromNib() -> Self
}

extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        return bundle.loadNibNamed(nibName, owner: nil)!.first! as! Self
    }
}

// MARK: - NibOwnerLoadable

public protocol NibOwnerLoadable: class {
    static var nib: UINib { get }
}

public extension NibOwnerLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: - NibViewController

class NibViewController<View>: UIViewController where View: UIView & NibLoadable {
    var v: View!
    
    override func loadView() {
        v = View.loadFromNib()
        view = v
    }
    
    deinit {
        print("\(self) deinit")
    }
}
