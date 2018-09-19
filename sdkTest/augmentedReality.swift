//
//  augmentedReality.swift
//  
//
//  Created by Andrew Vanbeek on 2/1/18.
//

import Foundation
import CoreLocation
import SCLAlertView
import SceneKit
import SpriteKit
import ARKit
import ObjectiveC
import ARCL
import GooglePlaces
import GoogleMaps

var AssociatedObjectKey: UInt8 = 7



class AugViewController: UIViewController {
    
    let manager = CLLocationManager()
    var location = CLLocation()
    var searchType = String()
    var iconImage = UIImage()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[0]
  
        
        
        // Creates a marker in the center of the map.
        
        
        
        
        
        
        
        let loader = PlacesLoader()
        
        //"Join AAA", "Request Roadside Assistance", "Cheapest Gas", "Find airport", "Book Hotel", "Book Car"
        loader.loadPOIS(location: location, radius: 100, type: "food") { placesDict, error in
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
                        let image = UIImage(named: "logo")!
                        let skScene = SKScene(size: CGSize(width: 200, height: 200))
                        skScene.backgroundColor = UIColor.blue
                        let annotationNode = LocationAnnotationNode(location: location, image: image)
                        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
                        self.sceneLocationView.addGestureRecognizer(tapGestureRecognizer)
                        annotationNode.setValue("test!!", forKey: "tester")
                        annotationNode.name = "testing"
                        
                       // marker.title = name
                     //self.iconImage
                       
                    }
                }
            }
        }
        
        manager.stopUpdatingLocation()
        
    }
    
     var sceneLocationView = SceneLocationView()
    var nodes = [String: String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyBy1wmf9ySN9NZuukP5nPAVJvFbxya0LTs")
        GMSPlacesClient.provideAPIKey("AIzaSyDCErVvqx8c3OJHZCjX3OprwDPrjpswSDo")
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        self.styleNavBar()
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        
        var currentLocation: CLLocation!
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locManager.location
            let loader = PlacesLoader()
            
            //"Join AAA", "Request Roadside Assistance", "Cheapest Gas", "Find airport", "Book Hotel", "Book Car"
            loader.loadPOIS(location: currentLocation, radius: 10000, type: "hotel") { placesDict, error in
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
                        print(name)
                        
                        let location = CLLocation(latitude: latitude, longitude: longitude)
                        DispatchQueue.main.async {
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            let image = UIImage(named: "hotel")!
                            var label = UILabel.init()
                             label.text = name
                            var subview = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                            let plane = SCNPlane(width: 20, height: 20)
                            let material = SCNMaterial()
                            material.isDoubleSided = true
//                            material.diffuse.contents = skScene
                            plane.materials = [material]
                            let text = SCNText(string: name, extrusionDepth: 1)
                            text.font = UIFont(name: "Helvetica", size: 5)
                            material.diffuse.contents = UIColor.lightBlue
                            text.materials = [material]
                            
                            let node = SCNNode(geometry: text)
                            
                            let annotationNode = LocationAnnotationNode(location: location, image: image)
                            node.position = annotationNode.position
                            annotationNode.addChildNode(node)
                            
                            self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
                            
            
                          
                            annotationNode.setValue("test!!", forKey: "tester")
                            annotationNode.name = "testing"
                            
                            // marker.title = name
                            //self.iconImage
                            
                        }
                    }
                }
            }
        }
        
        
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
     
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
     SCLAlertView().showInfo("Important info", subTitle: "You are great")
    }
    
    private func registerGestureRecognizers() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
//        self.sceneLocationView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        print("here")
        let sceneView = recognizer.view as! SceneLocationView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        if !hitResults.isEmpty {
            print("test")

            
        }
    }
    

}

extension UIImage {
    class func imageWithLabel(_ label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}




