//
//  PlacesLoader.swift
//  Mobile-Sign
//
//  Created by Andrew Van Beek on 5/19/17.
//  Copyright © 2017 Andrew Van Beek. All rights reserved.
//

import Foundation
import CoreLocation
import KeychainSwift

let apiURL = "https://copu0v8hc7.execute-api.us-west-2.amazonaws.com/avbTest"
var appConfigVar = OktaConfiguration()


let apiKey = appConfigVar.gmapsKey

struct PlacesLoader {
    
    
    func loadPOIS(location: CLLocation, radius: Int = 30, type: String, handler: @escaping (NSDictionary?, NSError?) -> Void) {
        print("Load pois")
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let keychain = KeychainSwift()
        let uri = apiURL + "?location=\(latitude),\(longitude)&types=\(type)"
        
        print(uri)
        let url = URL(string: uri)!
        var request = URLRequest(url: URL(string: uri)!)
        request.setValue("Bearer " + keychain.get("atoken")!, forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        print("###########")
        print(request)
          print("###########")
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print(data!)
                    
                    do {
                        let responseObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        guard let responseDict = responseObject as? NSDictionary else {
                            return
                        }
                        
                        handler(responseDict, nil)
                        
                    } catch let error as NSError {
                        handler(nil, error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    
    
}
