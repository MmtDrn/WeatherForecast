//
//  LocationServices.swift
//  Restaurants
//
//  Created by MacBook on 25.07.2022.
//

import Foundation
import CoreLocation

final class LocationServices:NSObject {
    
    let manager:CLLocationManager
    
    var changeLocation: ((Bool) ->Void)?
    
    var status:CLAuthorizationStatus {
        return CLLocationManager().authorizationStatus
    }
    
    init(manager:CLLocationManager = .init()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
    }
    
    func getPermisson() {
        manager.requestWhenInUseAuthorization()
    }
}

extension LocationServices: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
            
        case .denied, .restricted, .notDetermined:
            self.changeLocation?(false)
            break
        default:
            self.changeLocation?(true)
        }
        
    }
}
