//
//  LocationInformation.swift
//
//
//  Created by Theik Chan on 13/03/2024.
//

import Foundation
import UIKit
import CoreLocation

class Locator: NSObject, CLLocationManagerDelegate {
    enum Result <T> {
        case Success
        case Failure(Error)
    }
    
    static let shared: Locator = Locator()
    
    typealias Callback = (Result <Locator>) -> Void
    
    var requests: Array <Callback> = Array <Callback>()
    
    var location: CLLocation? { return sharedLocationManager.location  }
    
    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        return newLocationmanager
    }()
    
    // MARK: - Authorization
    
    class func authorize() { shared.authorize() }
    func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }
    
    // MARK: - Helpers
    
    func locate(callback: @escaping Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }
    
    func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }
    
    class func checkAuthorizeLocation() -> Bool{
        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways){
            return true
        }else {
            return false
        }
    }
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    private var messagesData: Data? {
        let batch: [String: AnyObject] = [
            "longLat": "\(Locator.getLatitude()):\(Locator.getLongitude())" as AnyObject,
            "time": getCurrentMillis() as AnyObject,
            "device_id": UUID().uuidString as AnyObject,
            "locationRaw":"raw location" as AnyObject]
        return try? JSONSerialization.data(withJSONObject: batch, options: [])
    }
    
    class func getLatitude() -> CLLocationDegrees{
        return (Locator.shared.sharedLocationManager.location?.coordinate.latitude)!
    }
    
    class func getLongitude() -> CLLocationDegrees {
        return (Locator.shared.sharedLocationManager.location?.coordinate.longitude)!
    }
    
    class func openAppSetting() {
        guard let settingUrl = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingUrl) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingUrl)
        } else {
            UIApplication.shared.openURL(settingUrl)
        }
    }
    
    // MARK: - Delegate
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        for request in self.requests { request(.Failure(error)) }
        self.reset()
    }
    
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        for request in self.requests { request(.Success) }
        self.reset()
    }
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
}
