//
//  ExTableView.swift
//  HelloSwift
//
//  Created by well on 2023/3/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.classString, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: cellType))")
        }
        return cell
    }
}
