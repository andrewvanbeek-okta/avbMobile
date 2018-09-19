//
//  mainColors.swift
//  sdkTest
//
//  Created by Andrew Vanbeek on 1/29/18.
//  Copyright © 2018 Andrew Vanbeek. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import ViewAnimator

extension UIColor {
    
    static let mainBackBlue = UIColor(red:0.08, green:0.25, blue:0.29, alpha:1.0)
    static let lightBlue = UIColor(red:0.30, green:0.71, blue:0.98, alpha:1.0)
    
}


extension UIViewController {
    func styleNavBar(){
        self.view.backgroundColor = UIColor.mainBackBlue
        self.navigationItem.prompt = " ";
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        //self.navigationItem.titleView?.addSubview(imageView)
        self.navigationController?.navigationBar.addSubview(imageView)
        self.navigationController?.modalTransitionStyle = .partialCurl
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 160, height: 160))
            make.center.equalTo((self.navigationController?.navigationBar)!)
            //            make.centerY.equalTo((self.navigationController?.navigationBar)!).offset(-10)
        }
        imageView.layer.zPosition = 200
    }
}

extension UIImage {
    convenience init(view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
        
    }
}

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

