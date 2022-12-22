//
//  Helpers.swift
//  weather-app-tech-test
//
//  Created by Russell Warwick on 19/12/2022.
//

import UIKit

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension UICollectionViewCell {
    static var id: String { String(describing: self) }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.id)
    }
    
    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: T.id, for: indexPath) as? T
    }
}
