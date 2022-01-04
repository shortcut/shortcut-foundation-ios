//
//  Collection+Extension.swift
//  ShortcutFoundation
//
//  Created by Andreas Lif on 2021-11-15.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
