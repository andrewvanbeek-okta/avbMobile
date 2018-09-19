//
//  menu.swift
//  sdkTest
//
//  Created by Andrew Vanbeek on 1/29/18.
//  Copyright © 2018 Andrew Vanbeek. All rights reserved.
//

import Foundation
import UIKit
import ViewAnimator
import SnapKit
import FontAwesome_swift
import SwiftIcons
import OktaAuth
import AppAuth
import Alamofire
import SwiftyJSON
import SCLAlertView
import OktaAuth

    var appConfig = OktaConfiguration()

class Menu: UITableViewController {
    var menuItems = ["Directory", "Account", "AR View", "Saml in to Box","Logout"]
    override func viewDidLoad() {
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(poll), userInfo: nil, repeats: true)
        super.viewDidLoad()
        self.styleTheView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.styleTheView()
        if(self.menuItems.last != "Logout") {
            //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(poll), userInfo: nil, repeats: true)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 5
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let animation = AnimationType.from(direction: .top, offset: 10.0)
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        let view = UIView()
        cell.contentView.addSubview(view)
        cell.contentView.backgroundColor = UIColor.mainBackBlue
        view.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.edges.equalTo(cell.contentView).inset(UIEdgeInsetsMake(10, 10, 10, 10))
            make.center.equalTo(cell.contentView)
        }
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 10
        self.styleTextLabel(label: cell.textLabel!, menuItem: menuItems[indexPath.row])
        return cell
    }
    
    // method to run when table view cell is tapped
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        if(menuItems[indexPath.row] == "Logout" ){
            OktaAuth.clear()
            self.logThemOut()
        } else if(menuItems[indexPath.row] == "Account") {
            OktaAuth
                .userinfo() { response, error in
                    if error != nil {
                        print("Error: \(error!)")
                    }
                    
                    if let userinfo = response {
                      var array = [""]
                        userinfo.forEach {
                            //print("\($0): \($1)")
                            array.append("\($0): \($1) \n" )
                        }
                        var userInfo = array.joined()
                        print(userInfo)
                        DispatchQueue.main.async() {
                            SCLAlertView().showInfo("User info", subTitle: userInfo)
                        }
        
                        
                    }
            }
        } else if(menuItems[indexPath.row] == "Saml in to Box") {
//            OktaAuth
//                .login()
//                .samlStart(self) {
//                    response, error in
//                    if error != nil { print(error!) }
//            }
            var config = OktaAuth.configuration
            var samlConfig = OIDServiceConfiguration(authorizationEndpoint: URL(string: "https://auth.vanbeeklabs.com/home/boxnet/0oa1z7hoa5m7JQgWs1t7/72")!, tokenEndpoint:  URL(string: "https://auth.vanbeeklabs.com/home/boxnet/0oa1z7hoa5m7JQgWs1t7/72")!)
            let request = OIDAuthorizationRequest(
                configuration: samlConfig,
                clientId: config!["clientId"] as! String,
                scopes: try? Utils().scrubScopes(config?["scopes"]),
                redirectURL: URL(string: config!["redirectUri"] as! String)!,
                responseType: OIDResponseTypeCode,
                additionalParameters: nil
            )
            OIDAuthState.authState(byPresenting: request, presenting: self){
                authorizationResponse, error in
                
            }
        }
    }
    
    func styleTheView() {
        self.view.backgroundColor = UIColor.mainBackBlue
        self.tableView.backgroundColor = UIColor.mainBackBlue
        self.tableView.tableFooterView = UIView()
        self.navigationItem.prompt = " ";
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        //self.navigationItem.titleView?.addSubview(imageView)
        self.navigationController?.navigationBar.addSubview(imageView)
        self.navigationController?.modalTransitionStyle = .partialCurl
        let animation = AnimationType.from(direction: .top, offset: 10.0)
        let animationTwo = AnimationType.from(direction: .bottom, offset: 10.0)
        //tableView.animate(animations: [animation, animationTwo], reversed: 0.8)
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 160, height: 160))
            make.center.equalTo((self.navigationController?.navigationBar)!)
//            make.centerY.equalTo((self.navigationController?.navigationBar)!).offset(-10)
        }
        imageView.layer.zPosition = 200
    }
    
    func navigationIcon(menuItem: String) -> UIImage {
        var size = 50
        if(menuItem == "Map"){
            return UIImage.fontAwesomeIcon(name: .mapO, textColor: UIColor.white, size: CGSize(width: size, height: size))
        } else if(menuItem == "Directory"){
            return UIImage.fontAwesomeIcon(name: .addressBook, textColor: UIColor.white, size: CGSize(width: size, height: size))
        } else if(menuItem == "Account"){
            return UIImage.fontAwesomeIcon(name: .userO, textColor: UIColor.white, size: CGSize(width: size, height: size))
        } else if(menuItem == "AR View"){
            return UIImage.fontAwesomeIcon(name: .cameraRetro, textColor: UIColor.white, size: CGSize(width: size, height: size))
        } else {
            return UIImage.fontAwesomeIcon(name: .signOut, textColor: UIColor.white, size: CGSize(width: size, height: size))
        }
       
    }
    
    func styleTextLabel(label: UILabel, menuItem: String){
        label.textAlignment = .center
        var item = "     " + menuItem
        var font = UIFont(name: "Futura", size: 16)
        if(menuItem == "Map"){
            label.setIcon(prefixText: "", prefixTextFont: font!, prefixTextColor: .white, icon: .icofont(.map), iconColor: UIColor.mainBackBlue, postfixText: item, postfixTextFont: font!, postfixTextColor: UIColor.mainBackBlue, iconSize: 35)
        } else if(menuItem == "Directory"){
             label.setIcon(prefixText: "", prefixTextFont: font!, prefixTextColor: .white, icon: .icofont(.contacts), iconColor: UIColor.mainBackBlue, postfixText: item, postfixTextFont: font!, postfixTextColor: UIColor.mainBackBlue, iconSize: 35)
        } else if(menuItem == "Account"){
             label.setIcon(prefixText: "", prefixTextFont: font!, prefixTextColor: .white, icon: .icofont(.userAlt5), iconColor: UIColor.mainBackBlue, postfixText: item, postfixTextFont: font!, postfixTextColor: UIColor.mainBackBlue, iconSize: 35)
     
        } else if(menuItem == "AR View"){
            label.setIcon(prefixText: "", prefixTextFont: font!, prefixTextColor: .white, icon: .icofont(.camera), iconColor: UIColor.mainBackBlue, postfixText: item, postfixTextFont: font!, postfixTextColor: UIColor.mainBackBlue, iconSize: 35)
        } else {
      label.setIcon(prefixText: "", prefixTextFont: font!, prefixTextColor: .white, icon: .icofont(.signOut), iconColor: UIColor.mainBackBlue, postfixText: item, postfixTextFont: font!, postfixTextColor: UIColor.mainBackBlue, iconSize: 35)
        }
        
        label.textColor = UIColor.black
      
    }
    
    func logThemOut() {
        
        var config = OktaAuth.configuration
        var samlConfig = OIDServiceConfiguration(authorizationEndpoint: URL(string: "https://auth.vanbeeklabs.com/login/signout?fromUri=com.okta.sdkvanbeektech:/openid")!, tokenEndpoint:  URL(string: "https://auth.vanbeeklabs.com/login/signout?fromUri=com.okta.sdkvanbeektech:/openid")!)
        let request = OIDAuthorizationRequest(
            configuration: samlConfig,
            clientId: config!["clientId"] as! String,
            scopes: try? Utils().scrubScopes(config?["scopes"]),
            redirectURL: URL(string: config!["redirectUri"] as! String)!,
            responseType: OIDResponseTypeCode,
            additionalParameters: nil
        )
        OIDAuthState.authState(byPresenting: request, presenting: self){
            authorizationResponse, error in
            print(error)
            
        }
        
//        print("User Logged Out")
//        print(tokens?.accessToken)
//        print(tokens?.idToken)
//        let token = OktaAuth.tokens?.get(forKey: "accessToken")
//        let idToken = OktaAuth.tokens?.get(forKey: "idToken")
//        var auth_token = UserDefaults.standard.value(forKey: "user_auth_token")!
//        var userId = getJwtBodyString(token: auth_token as! String) as String
//        let gotoplace: String = "https://vanbeektech.okta.com/api/v1/users/" + userId + "/sessions"
//        let header: [String : String] = ["Authorization" : appConfig.token as! String]
//
//
//        Alamofire.request(gotoplace, method: .delete, parameters: ["user": ""], encoding: JSONEncoding.default, headers: header).responseJSON{ response in
//
//            guard response.result.error == nil else {
//                // got an error in getting the data, need to handle it
//                print(response.result.error!)
//                return
//            }
//
//            guard response.result.error != nil else {
//                // got an error in getting the data, need to handle it
//                print(response)
//                DispatchQueue.main.async() {
//                    self.performSegue(withIdentifier: "signout", sender: nil)
//                }
//
//                return
//            }
//
//
//        }
        DispatchQueue.main.async() {
            self.performSegue(withIdentifier: "signout", sender: nil)
        }
        
    }
    
  
    
    
    func multifactor() {
        print("User Logged Out")
        
        let gotoplace: String = "https://vanbeektech.okta.com/api/v1/users/00u1r5knwoSpMubTC1t7/factors/opf4e73idzj9p3LXe1t7/verify"
        let header: [String : String] = ["Authorization" : appConfig.token as! String]
        
        
        Alamofire.request(gotoplace, method: .post, parameters: ["answer": "Annie Oakley"], encoding: JSONEncoding.default, headers: header).responseJSON{ response in
      
            do {
                let json = try JSON(data: response.data!)
                print(json)
                let links = json["_links"].dictionaryValue
                print(links)
                let poll = links["poll"]?.dictionaryValue
                print(poll)
                let successUrl = poll!["href"]!.string!
                print(successUrl)
                self.menuItems.append(successUrl)
                print(self.menuItems)
                self.tableView.reloadData()
                   print("cheeky")
                   print("cheeky")
                   print("cheeky")
                   print("cheeky")
                   print("cheeky")
                
                return
            } catch {
                print("cheeky")
            }
        }
    }
    
    
    @objc func poll() {
        var successUrl = self.menuItems.last!
        print("is polling for success")
         let header: [String : String] = ["Authorization" : appConfig.token as! String]
        Alamofire.request(successUrl, method: .get, parameters: ["user": "test"], encoding: JSONEncoding.default, headers: header).responseJSON{ response in
            
            print(response)
            
        }
    }
    
    func getJwtBodyString(token: String) -> String {
        var tokenstr = token
        var segments = tokenstr.components(separatedBy: ".")
        var base64String = segments[1]
        print("\(base64String)")
        let requiredLength = Int(4 * ceil(Float(base64String.characters.count) / 4.0))
        let nbrPaddings = requiredLength - base64String.characters.count
        if nbrPaddings > 0 {
            let padding = String().padding(toLength: nbrPaddings, withPad: "=", startingAt: 0)
            base64String = base64String.appending(padding)
        }
        base64String = base64String.replacingOccurrences(of: "-", with: "+")
        base64String = base64String.replacingOccurrences(of: "_", with: "/")
        let decodedData = Data(base64Encoded: base64String, options: Data.Base64DecodingOptions(rawValue: UInt(0)))

        do {
            var tokenJson = try JSON(data: decodedData!)
            var uid = tokenJson["uid"]
            print("#####")
            print(uid)
            print("#####")
            return uid.string!
        } catch {
            
        }
        
        
        return "hey"
    }
    
    
}
