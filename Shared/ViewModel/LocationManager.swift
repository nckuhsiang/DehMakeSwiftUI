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
    @Published var address:String = ""
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
    func getLocation() {
        
        let lat = locationManager.location?.coordinate.latitude ?? 0.0
        let long = locationManager.location?.coordinate.longitude ?? 0.0
        print(lat,long)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: lat , longitude: long), completionHandler: {
           (placemarks,error) -> Void in
           if error != nil{
//              print(error)
              return
           }
           //name         街道地址
           //country      國家
           //province     省
           //locality     市
           //sublocality  縣.區
           //route        街道、路
           //streetNumber 門牌號碼
           //postalCode   郵遞區號
            if let marks = placemarks {
                if marks.count > 0{
                    let mark = marks[0] as CLPlacemark
                    self.address = mark.name!
                    print(self.address)
                   //這邊拼湊轉回來的地址
                   //placemark.name
            }
           
           }
        })
        latitude = String(format: "%.6f", lat)
        longitude = String(format: "%.6f", long)
        
        showCompleteAlert = true
    }
    
}
