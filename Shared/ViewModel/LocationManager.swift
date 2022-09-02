//
//  LocationManager.swift
//  DehMakeSwiftUI (iOS)
//
//  Created by 陳家庠 on 2022/2/9.
//

import Foundation
import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var longitude:String = ""
    @Published var latitude:String = ""
    @Published var address:String  = ""
    @Published var showCompleteAlert = false
    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
//        print(#function, location)
    }
    func getLocation(completion: @escaping (String) -> Void) {

        let long = (locationManager.location?.coordinate.longitude) ?? 0.0
        let lat = (locationManager.location?.coordinate.latitude) ?? 0.0
        latitude = String(format: "%.6f", lat)
        longitude = String(format: "%.6f", long)

        let location = CLLocation(latitude: lat, longitude: long)
        print(location)

        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)

            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }

            if placemarks!.count > 0 {
                let pm = placemarks![0]
                completion(pm.name!)
            }
                else {
                    print("Problem with the data received from geocoder")
            }
        })
        showCompleteAlert = true
     }
    
}
