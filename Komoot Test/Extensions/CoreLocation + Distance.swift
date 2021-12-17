//
//  CoreLocation + Distance.swift
//  Komoot Test
//
//  Created by Дмитрий Пичугин on 10.10.2021.
//

import CoreLocation

extension CLLocationCoordinate2D {

    /// Returns the distance between two coordinates in meters.
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: latitude, longitude: longitude)
            .distance(from: CLLocation(latitude: to.latitude, longitude: to.longitude))
    }

}
