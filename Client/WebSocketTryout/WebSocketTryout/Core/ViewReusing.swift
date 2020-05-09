//
//  ViewReusing.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 05.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import UIKit


protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    final func register<Cell>(cellType: Cell.Type) where Cell: UITableViewCell, Cell: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<Cell>(
        for indexPath: IndexPath, cellType: Cell.Type
    ) -> Cell where Cell: UITableViewCell, Cell: Reusable {
        
        return dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as! Cell
    }
}
