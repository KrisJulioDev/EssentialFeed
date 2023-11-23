//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Khristoffer Julio on 11/13/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
