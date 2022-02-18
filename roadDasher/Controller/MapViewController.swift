//
//  MapViewController.swift
//  roadDasher
//
//  Created by LiangTing Lin on 2022/2/17.
//

import UIKit
import CoreLocation
import MapKit
import CoreData
class MapViewController: UIViewController {
    var manager: CLLocationManager = CLLocationManager()
    var latitude: Double = 25.03407286999999
    var longitude: Double = 121.54360960999996
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var showLocationBtnPressed: UIButton!
    
    
    
    @IBAction func showLocationBtnPressed(_ sender: Any) {
        
       
      

        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
        
        
        print("Start Showing and Reporting my location")

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let fetchLocation = locations.first(where: { $0.horizontalAccuracy >= 0 }) else {
            return
        }
        
        self.latitude = fetchLocation.coordinate.latitude
        self.longitude = fetchLocation.coordinate.longitude
        print("Lat: \( self.latitude) Lon:\(self.longitude)")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.activityType = .fitness
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        manager.pausesLocationUpdatesAutomatically = false
        
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
       
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MapViewController: CLLocationManagerDelegate{
    
    
}

extension MapViewController: MKMapViewDelegate{
    
    
}

