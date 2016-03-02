//
//  ProductsClass.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit

class Product {
    var Name: String = ""
    var Price: Double = 0
    var objectId: String = ""
    let imageUrl: NSURL
    //var Image: UIImage
    //var Id: String = ""
    var Imgreq : NSURLRequest?
    var Description: String = ""
    var weight : Double = 0
    init(name : String, price: Double,ImageUrl: NSURL, id: String){
        self.Name = name
        self.Price = price
        self.imageUrl = ImageUrl
        self.objectId = id
    }
    
}
