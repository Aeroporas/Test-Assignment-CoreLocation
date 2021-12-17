//
//  UIViewController + AlertView.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import UIKit

extension UIViewController {
    func showAlertView(header: String? = nil, text: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: header, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
}

