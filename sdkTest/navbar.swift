//
//  navbar.swift
//  sdkTest
//
//  Created by Andrew Vanbeek on 1/29/18.
//  Copyright © 2018 Andrew Vanbeek. All rights reserved.
//

import Foundation
import UIKit


let navigationNormalHeight: CGFloat = 44
let navigationExtendHeight: CGFloat = 84

extension UINavigationBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var barHeight: CGFloat = navigationNormalHeight
        
        if size.height == navigationExtendHeight {
            barHeight = size.height
        }
        
        let newSize: CGSize = CGSize(width: self.frame.size.width, height: barHeight)
        return newSize
    }
}
