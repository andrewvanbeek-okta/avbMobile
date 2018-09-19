//
//  ContactsController.swift
//  Mobile-Sign
//
//  Created by Andrew Van Beek on 4/20/17.
//  Copyright © 2017 Andrew Van Beek. All rights reserved.
//

import Foundation

import UIKit

import Alamofire

var SendNotifications = true

class ContactsController: UITableViewController {
    
    
    
    //MARK: INSTANCE VARIABLES & CONSTANTS
    
    var table = ["Loading Users", ""]
    
    
    var appConfig = OktaConfiguration()
    //MARK: FUNCTIONS
    
    func siteInfo() -> Void {
        
        let url = "\(appConfig.kIssuer as String)/api/v1/users"
        print(appConfig.token)
        let header: [String : String] = ["Authorization" : appConfig.token as String!]
        Alamofire.request(url, headers: header).responseJSON{ response in
            var tableInfoToBeInserted = [String]()
            guard response.result.error != nil else {
                
                // got an error in getting the data, need to handle it
                let json = response.result.value as! NSArray
                for i in 0 ..< json.count  {
                    let userInfoBlob = json[i] as! NSDictionary
                    print(userInfoBlob)
                    let profile = userInfoBlob["profile"] as! NSDictionary
                
                    let firstName = profile["firstName"] as! String
                    let lastName = profile["lastName"] as! String
                    let name = "\(firstName) \(lastName)"
                    let email = profile["email"] as! String
                    var type = ""
                    var credentials = userInfoBlob["credentials"] as! NSDictionary
                    if(credentials["provider"] != nil) {
                        var provider = credentials["provider"] as!  NSDictionary
                        type = provider["type"] as! String
                    }
                   
                    let userString = "Name: \(name.capitalized), \n Email: \(email.capitalized), active: \(userInfoBlob["activated"]), status: \(userInfoBlob["status"]), provider: \(type)"
                    tableInfoToBeInserted.append(userString)
              
                    
                }
            
                self.table = tableInfoToBeInserted as NSArray as! [String]
                self.tableView.reloadData()
                return
            }
            
        }
        
        
        
        //          //
        
        
        
        
    }
    
    
    
    //MARK: OVERRIDE FUNCTIONS
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        siteInfo()
        
        print(table)
        self.styleNavBar()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        siteInfo()
        
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (table.count)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 10
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.text = table[indexPath.row]
        cell.backgroundColor = .clear
        let image = UIImage(named: "tablebg.png")
        let imageView = UIImageView(image: image)
        
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let scale: CGFloat = CGFloat(table.count * 10)
        let screenHeight = screenSize.height * scale
        imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
        cell.textLabel?.font = UIFont(name:"Futura", size:14)
        cell.textLabel?.textColor = UIColor.white
        
        return cell
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
        
    {
        
        if editingStyle == UITableViewCellEditingStyle.delete
            
        {
            
            let deletion = table[indexPath.row]
            
            let itemInfo = ["list_id": 1, "name": deletion] as [String : Any]
            
            Alamofire.request("http://localhost:3000/users/1", method: .delete, parameters: ["item": itemInfo], encoding: JSONEncoding.default)
                
                .responseJSON { response in
                    
            }
            
            table.remove(at: indexPath.row)
            
            tableView.reloadData()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0;
    }
    
    
    
}



