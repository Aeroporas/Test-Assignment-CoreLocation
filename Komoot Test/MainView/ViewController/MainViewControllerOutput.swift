//
//  MainViewControllerOutput.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import Foundation
import CoreLocation

protocol MainViewControllerOutput: AnyObject {
    func didPressBarButton(buttonState: BarButtonState)
    
    var tableViewModel: MainViewControllerViewModel { get }
    
    func didUpdateLocations (_ locations: [CLLocation])
}
