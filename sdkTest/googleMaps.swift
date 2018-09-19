//
//  MapsController.swift
//  Mobile-Sign
//
//  Created by Andrew Van Beek on 4/22/17.
//  Copyright © 2017 Andrew Van Beek. All rights reserved.
//
import Foundation

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import AppAuth
import SnapKit
import FontAwesome_swift
import SCLAlertView
import SwiftIcons


var mapType = "Cheapest Gas"

class MapsController: UIViewController, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var location = CLLocation()
    var searchType = String()
    var iconImage = UIImage()
    
    @IBOutlet weak var googleMapsView: GMSMapView!
    
    
  
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: 15)
        self.googleMapsView.camera = camera
        self.googleMapsView.isMyLocationEnabled = true
        
        
        // Creates a marker in the center of the map.
        
        
        
        
        
        
       
        let loader = PlacesLoader()

        //"Join AAA", "Request Roadside Assistance", "Cheapest Gas", "Find airport", "Book Hotel", "Book Car"
        loader.loadPOIS(location: location, radius: 10000, type: self.searchType) { placesDict, error in
            //3
            if let dict = placesDict {
                let placesArray = dict.object(forKey: "results") as? [NSDictionary]
                //2
                for placeDict in placesArray! {
                    //3
                    
                    print("gest heere")
                    let latitude = placeDict.value(forKeyPath: "geometry.location.lat") as! CLLocationDegrees
                    let longitude = placeDict.value(forKeyPath: "geometry.location.lng") as! CLLocationDegrees
                    _ = placeDict.object(forKey: "reference") as! String
                    let name = placeDict.object(forKey: "name") as! String
                    
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    DispatchQueue.main.async {
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        
                        marker.title = name
                        marker.icon = self.iconImage
                        
                        marker.map = self.googleMapsView
                    }
                }
            }
        }
        
        manager.stopUpdatingLocation()
        
    }
    
    override func viewDidLoad() {
        self.searchType = ""
        self.iconImage = UIImage.init(bgIcon: .mapicons(.mapPin), bgTextColor: .mainBackBlue, topIcon: .mapicons(.lodging), topTextColor: .white, bgLarge: true)
        GMSServices.provideAPIKey("AIzaSyBy1wmf9ySN9NZuukP5nPAVJvFbxya0LTs")
        GMSPlacesClient.provideAPIKey("AIzaSyDCErVvqx8c3OJHZCjX3OprwDPrjpswSDo")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        self.styleNavBar()
        self.googleMapsView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(5, 5, 5, 5))
            make.center.equalTo(self.view)
        }
    
        let findPlaces = UIBarButtonItem(title: "Display", style: .plain, target: self, action: #selector(rightButtonAction))
        
        self.navigationItem.rightBarButtonItems = [findPlaces]
        let attributes = [NSAttributedStringKey.font.rawValue: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        
        findPlaces.setIcon(icon: .icofont(.map), iconSize: 30, color: UIColor.lightBlue)
    }
    
    @objc func rightButtonAction() {
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        let alertViewIcon = UIImage(named: "logo") //Replace the IconImage text with the image name
        alertView.addButton("Gas") {
            mapType = "Cheapest Gas"
            self.searchType = "gas_station"
             self.iconImage = UIImage(named: "gaspump")!
            
            self.googleMapsView.clear()
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
        }
        alertView.addButton("Car Rentals") {
            self.searchType = "car_rental"
               self.iconImage = UIImage(named: "bookcar")!
            self.googleMapsView.clear()
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
        }
        
        alertView.addButton("Hotels") {
            self.searchType = "lodging"
            self.iconImage = UIImage(named: "hotel")!
            self.googleMapsView.clear()
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
        }
        
        alertView.addButton("Airplane") {
            self.searchType = "airpot"
            self.iconImage = UIImage(named: "airplane")!
            self.googleMapsView.clear()
            self.manager.desiredAccuracy = kCLLocationAccuracyBest
            self.manager.requestWhenInUseAuthorization()
            self.manager.startUpdatingLocation()
        }
        
      
     
        alertView.showInfo("What are you Searching for?", subTitle: "Just Select", circleIconImage: alertViewIcon)

    }
}
