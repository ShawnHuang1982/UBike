//
//  FlowController+Location.swift
//  testUBike
//
//  Created by shawn on 2019/12/11.
//  Copyright © 2019 yu-syue huang. All rights reserved.
//

import CoreLocation

extension FlowController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.userLocation = locations.first
        flowControlViewModel.userLocation = self.userLocation
        self.listVC.viewModels = flowControlViewModel.sortedInfosByLocation
        self.mapVC.listViewModel = flowControlViewModel.sortedInfosByLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while requesting new coordinates")
    }
}
