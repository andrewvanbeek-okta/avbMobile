//
//  ViewController.swift
//  sdkTest
//
//  Created by Andrew Vanbeek on 1/19/18.
//  Copyright © 2018 Andrew Vanbeek. All rights reserved.
//

import UIKit
import OktaAuth
import AppAuth
import ViewAnimator
import KeychainSwift

class ViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.styleTheView()
        print("#####################")
        let keychain = KeychainSwift()
        print(keychain.get("atoken"))
        print()

    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        if(OktaAuth.tokens?.get(forKey: "accessToken") != nil){
            
            self.toMenu()
        }
        
    }
    
    @IBAction func signIn(_ sender: Any) {
        self.authenticate()
    }
    func styleTheView() {
        self.view.backgroundColor = UIColor.mainBackBlue
    }
    
    func authenticate() {
        OktaAuth
            .login()
            .start(self) {
                response, error in
                
                if error != nil { print(error!) }
                
                // Success
                if let tokenResponse = response {
                   //UserDefaults.standard.set(tokenResponse.accessToken! as String, forKey: "accessToken")
                     //UserDefaults.standard.set(tokenResponse.accessToken! as String, forKey: "accessToken")
                    print(tokenResponse)
                
                   OktaAuth.tokens?.set(value: tokenResponse.accessToken!, forKey: "accessToken")
                    OktaAuth.tokens?.set(value: tokenResponse.idToken!, forKey: "idToken")
                    UserDefaults.standard.setValue(tokenResponse.accessToken!, forKey: "user_auth_token")
                    let keychain = KeychainSwift()
                    keychain.set(tokenResponse.accessToken!, forKey: "atoken")
                    DispatchQueue.main.async() {
                       
                             self.performSegue(withIdentifier: "toMenu", sender: nil)
                       
                       
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toMenu() {
       DispatchQueue.main.async() {
            self.performSegue(withIdentifier: "toMenu", sender: nil)
        }
    }
    



}

