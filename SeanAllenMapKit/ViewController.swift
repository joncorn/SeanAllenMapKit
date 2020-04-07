//
//  ViewController.swift
//  SeanAllenMapKit
//
//  Created by Jon Corn on 4/5/20.
//  Copyright © 2020 Jon Corn. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
  
  // MARK: - Properties
  let locationManager = CLLocationManager()
  let regionInMeters: Double = 10000
  
  // MARK: - Outlets
  @IBOutlet weak var mapView: MKMapView!
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    checkLocationServices()
  }
  
  // MARK: - Methods
  
  /// Checks if the device's global location permission is enabled
  /// Top level permissions -> are global services enabled
  /// Next level permissions -> which services did user allow us to use
  func checkLocationServices() {
    // Don't setup location manager unless location services are enabled
    if CLLocationManager.locationServicesEnabled() {
      // if top level permissions are good, setup location manager then check authorization status
      setupLocationManager()
      checkLocationAuthorization()
    } else {
      // Show alert letting the user know they have to turn this on
      
    }
  }
  
  
  func setupLocationManager() {
    // Sets delegate to be able to use protocol stubs below
    locationManager.delegate = self
    // Determines what kind of accuracy
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  
  func checkLocationAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      // this pulls up blue dot on map
      mapView.showsUserLocation = true
      centerViewOnUserLocation()
      // This starts updating the user's location, -> array of coordinates to use
      locationManager.startUpdatingLocation()
      break
    case .denied:
      // show alert instruction them how to turn on permissions
      break
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      // Show an alert letting them know what's up
      break
    case .authorizedAlways:
      break
    }
  }
  
  
  func centerViewOnUserLocation() {
    // declares 'location' to be our user's current location coordinates
    if let location = locationManager.location?.coordinate {
      // 'region' refers to the size of the screen (10000 by 10000 meters), the center being our location
      let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
      mapView.setRegion(region, animated: true)
    }
  }
  
} // Class end

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // if our last location has no value, return
    guard let location = locations.last else { return }
    // Create our center, being the last updated location's coordinates
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    // Create our region, using our location.last's as the center
    let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
    // This changes the "view" the user sees of the map
    mapView.setRegion(region, animated: true)
  }
  
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
  
}

