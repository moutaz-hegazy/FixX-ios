//
//  MapViewController.swift
//  Locations
//
//  Created by moutaz hegazy on 6/5/21.
//  Copyright © 2021 Esraa_Gohar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate,
MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    
    var country: String = " "
    var city: String = " "
    var area: String = " "
    var subArea: String = " "
    
    var delegete: AddressProtocol?
    
       @IBAction func myLocationBtn(_ sender: Any) {
           if(CLLocationManager.locationServicesEnabled()){
               locationManager.requestLocation()
               locationManager.startUpdatingLocation()
           }
       }
     
       @IBAction func searchBtn(_ sender: Any) {
           
           let searchController = UISearchController(searchResultsController: nil)
           searchController.searchBar.delegate = self
           present(searchController, animated: true, completion: nil)
       }
     
       @IBOutlet weak var myMap: MKMapView!
    
       
       let locationManager = CLLocationManager()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           
           if(CLLocationManager.locationServicesEnabled()){
               locationManager.requestLocation()
               locationManager.startUpdatingLocation()
           }
           
        
           myMap.delegate = self
           
           self.myMap.isUserInteractionEnabled = true
       
           let oLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongTapGesture(gestureRecgnizer:)))
           self.myMap.addGestureRecognizer(oLongTapGesture)
       }
       
       @objc func handleLongTapGesture(gestureRecgnizer: UILongPressGestureRecognizer){
           if(gestureRecgnizer.state != UIGestureRecognizer.State.ended){
               
               let annotaions = self.myMap.annotations
               self.myMap.removeAnnotations(annotaions)
               
               let touchLocation = gestureRecgnizer.location(in: myMap)
               let locationCoordinate = myMap.convert(touchLocation, toCoordinateFrom: myMap)
              
               
               let myPin = MKPointAnnotation()
               myPin.coordinate = locationCoordinate
               getAddressFromLatAndLon(lat: locationCoordinate.latitude, lon: locationCoordinate.longitude)
          //  DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                myPin.title = country + ", " + city + ", " + area + ", " + subArea
                myPin.subtitle = "hello"
                myMap.addAnnotation(myPin)
           // }
                         
           }
           if (gestureRecgnizer.state != UIGestureRecognizer.State.began){
                   return
           }
       }
       
       
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           
           let annotaions = self.myMap.annotations
           self.myMap.removeAnnotations(annotaions)
           
           if locations.first != nil{
               manager.stopUpdatingLocation()
               
               let coordinates = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
               
               let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
               
               let region = MKCoordinateRegion(center: coordinates, span: span)
               
               myMap.setRegion(region, animated: true)
            
            getAddressFromLatAndLon(lat: locationManager.location?.coordinate.latitude ?? 0.0, lon: locationManager.location?.coordinate.longitude ?? 0.0)
            
            let myPin = MKPointAnnotation()
            myPin.coordinate = coordinates
            
          //  DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
             myPin.title = country + ", " + city + ", " + area + ", " + subArea
                myPin.subtitle = "hello"
             myMap.addAnnotation(myPin)
      //   }
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           
           switch status {
           case .authorizedAlways:
               return
           case .authorizedWhenInUse:
               return
           case .denied:
               return
           case .restricted:
               locationManager.requestWhenInUseAuthorization()
           case .notDetermined:
               locationManager.requestWhenInUseAuthorization()
           default:
               locationManager.requestWhenInUseAuthorization()
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
       }
       
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           //ignore user
           self.view.isUserInteractionEnabled = false
           
           //activity indicator
           let activtyIndicator = UIActivityIndicatorView()
           activtyIndicator.center = self.view.center
           activtyIndicator.style = UIActivityIndicatorView.Style.medium
           activtyIndicator.hidesWhenStopped = true
           activtyIndicator.startAnimating()
           
           self.view.addSubview(activtyIndicator)
           
           //hide searchBar
           searchBar.resignFirstResponder()
           dismiss(animated: true, completion: nil)
           
           //create search request
           let searchRequest = MKLocalSearch.Request()
           searchRequest.naturalLanguageQuery = searchBar.text
           
           let activeSearch = MKLocalSearch(request: searchRequest)
           activeSearch.start { (response, error) in
               
               activtyIndicator.stopAnimating()
               self.view.isUserInteractionEnabled = true
               
               if(response == nil){
                   print("Error")
               }else{
                   //remove annotations
                   let annotaions = self.myMap.annotations
                   self.myMap.removeAnnotations(annotaions)
                   
                   if let latitude = response?.boundingRegion.center.latitude{
                       if let longitude = response?.boundingRegion.center.longitude{
                           
                           //create annotation
                    
                        self.getAddressFromLatAndLon(lat: latitude, lon: longitude)
                        
                        let myPin = MKPointAnnotation()
                        myPin.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                        
                      //  DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                        myPin.title = self.country + ", " + self.city + ", " + self.area + ", " + self.subArea
                        self.myMap.addAnnotation(myPin)
                   //  }
                          
    
                           //zooming in on annotation
                           let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                           let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                           let region = MKCoordinateRegion(center: coordinate, span: span)
                           self.myMap.setRegion(region, animated: true)
                       }
                   }
                   
               }
           }
           
       }
       
       
       func getAddressFromLatAndLon(lat: Double, lon: Double){
           var center = CLLocationCoordinate2D()
           let geo = CLGeocoder()
           center.latitude = lat
           center.longitude = lon
           
           let loc = CLLocation(latitude: center.latitude, longitude: center.longitude)
           geo.reverseGeocodeLocation(loc, completionHandler: { (placemarks, error) in
               if(error != nil){
                   print("error")
               }else{
                
                   let pm = placemarks! as [CLPlacemark]
               
                   if(pm.count > 0){
                       let pm = placemarks![0]
                       let country = pm.country
                       let city = pm.administrativeArea
                    
                        let subArea = pm.subLocality
                        let area = pm.locality
             
                    self.country = country ?? ""
                    self.city = city ?? ""
                    self.area = area ?? ""
                    self.subArea = subArea ?? ""
                
                       
                   }
               }
           })
       }
       
       
    @IBAction func backActionBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
       @IBAction func addAddressActionBtn(_ sender: Any) {
        
        delegete?.sendAddressBack(city: city, area: area, subArea: subArea)
           self.dismiss(animated: true, completion: nil)
       }

}
