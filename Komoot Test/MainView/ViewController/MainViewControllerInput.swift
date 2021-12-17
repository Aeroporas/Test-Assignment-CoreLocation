//
//  MainViewControllerInput.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import Foundation
import CoreLocation
import UIKit

protocol MainViewControllerInput: AnyObject {
    func showAlertView(header: String?, text: String, completion: ((UIAlertAction) -> Void)?)
    
    func updateBarButtonState(trackingIsInProgress: Bool)
    
    var locationManager: CLLocationManager? { get set }
    
    func shouldReloadTableViewCell(at index: Int)
}
