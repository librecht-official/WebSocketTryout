//
//  SwiftExt.swift
//  WebSocketTryout
//
//  Created by Vladislav Librecht on 08.05.2020.
//  Copyright © 2020 Vladislav Librecht. All rights reserved.
//

import Foundation


extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? ""
    }
}

extension Array where Element: Identifiable {
    mutating func merge(_ other: Self) {
        for element in other {
            if let existingIndex = self.firstIndex(where: { $0.id == element.id }) {
                self[existingIndex] = element
            } else {
                self.append(element)
            }
        }
    }
}
