//
//  CellWithImageViewModel.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import Foundation
import UIKit
import CoreLocation

struct CellWithImageViewModel {
    var image: UIImage?
    var error: Error?
    var location: CLLocation
    var dateString: String = Date().ISO8601Format()
}
