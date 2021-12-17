//
//  MainViewControllerPresenter.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import Foundation
import UIKit
import CoreLocation

class MainViewControllerPresenter {
    private var viewController: MainViewControllerInput
    private var model: MainViewControllerViewModel = []
    
    var tableViewModel: MainViewControllerViewModel {
        get {
            return model.reversed()
        }
    }
    
    // Used to prevent race condition when writing to model
    private let serialQueueForModelUpdates = DispatchQueue(label: "serial", qos: .userInteractive)
    
    init(viewController: MainViewControllerInput) {
        self.viewController = viewController
    }
    
    private func addNewPoint(with location: CLLocation) {
        model.append(CellWithImageViewModel(image: nil, error: nil, location: location))
        viewController.shouldReloadTableViewCell(at: 0)
        loadPhotosList(for: location)
    }
    
    private func loadPhotosList(for location: CLLocation) {
        NetworkService.shared.sendSearchRequestForImage(location: location) { [weak self] result, location in
            guard let self = self else { return }
            self.serialQueueForModelUpdates.async {
                guard let targetModelItemIndex = self.model.firstIndex(where: {$0.location == location}) else {
                    assertionFailure()
                    return
                }
                switch result {
                case .success(let photoDetails):
                    self.loadPhoto(for: photoDetails, location: location)
                case .failure(let error):
                    self.model[targetModelItemIndex].error = error
                }
                
                DispatchQueue.main.async {
                    self.viewController.shouldReloadTableViewCell(at: 0)
                }
            }
            
        }
    }
    
    private func loadPhoto(for photoDetails: Photo, location: CLLocation) {
        NetworkService.shared.loadImageFromServer(location: location, photoDetails: photoDetails) { [weak self] result, location in
            
            guard let self = self else { return }
            self.serialQueueForModelUpdates.async {
                guard let targetModelItemIndex = self.model.firstIndex(where: {$0.location == location}) else {
                    assertionFailure()
                    return
                }
                switch result {
                case .success(let image):
                    self.model[targetModelItemIndex].image = image
                case .failure(let error):
                    self.model[targetModelItemIndex].error = error
                }
                
                DispatchQueue.main.async {
                    self.viewController.shouldReloadTableViewCell(at: 0)
                }
            }
        }
    }
}

extension MainViewControllerPresenter: MainViewControllerOutput {
    func didUpdateLocations(_ locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("new location with coordiantes \(location.coordinate.latitude) and \(location.coordinate.longitude) received at \(Date().ISO8601Format())")
        
        if model.isEmpty {
            addNewPoint(with: location)
            return
        }

        guard let lastSavedPoint = model.last?.location else { return }
        // Although the filter option on locationManager is set to filter out all change less than 100m it still sometime provides points with lower distance between them
        if location.distance(from: lastSavedPoint) < 100 { // ignore all new points that are closer than 100m to the last saved point
            return 
        }
        addNewPoint(with: location)
    }
    
    func didPressBarButton(buttonState: BarButtonState) {
        switch buttonState {
        case .Start:
            if viewController.locationManager?.authorizationStatus != .authorizedAlways {
                viewController.showAlertView(header: "Error", text: "In order to allow app to track your location in background please change privacy settings for location tracking to Always allow", completion: nil)
                return
            }
            viewController.updateBarButtonState(trackingIsInProgress: true)
            
            
            viewController.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            viewController.locationManager?.allowsBackgroundLocationUpdates = true
            viewController.locationManager?.startUpdatingLocation()
            viewController.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            viewController.locationManager?.pausesLocationUpdatesAutomatically = true
            viewController.locationManager?.distanceFilter = 100
        case .Stop:
            viewController.locationManager?.stopUpdatingLocation()
            viewController.updateBarButtonState(trackingIsInProgress: false)
        }
    }
}
