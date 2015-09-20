//
//  UIColor +MyColor.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 29.07.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    class func appColor() -> UIColor {
        return UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 1)
    }
}
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
