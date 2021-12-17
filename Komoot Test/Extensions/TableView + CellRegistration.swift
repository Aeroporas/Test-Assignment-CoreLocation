//
//  TableView + CellRegistration.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import UIKit

extension UITableView {
    public func dequeueReusableCellWithRegistration<T: UITableViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        
        let reuseIdentifier = String(describing: T.self)
        
        if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
            return cell
        }
        
        register(
            UINib(nibName: reuseIdentifier, bundle: Bundle(for: T.self)),
            forCellReuseIdentifier: reuseIdentifier
        )
        
        if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T {
            return cell
        } else {
            assertionFailure("Could not dequeue cell with reuseId \(reuseIdentifier)")
            return T()
        }
    }
}
