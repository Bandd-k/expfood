//
//  TypeClass.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import Foundation
import UIKit

class Type2 {
    var name:String = ""
    var image:UIImage = UIImage(named: "type1.png")!
    var id:String = ""
    init(Name: String, Image: String, Id: String) {
        self.name = Name
        self.image = UIImage(named: Image)!
        self.id = "\(Id)"
    }
}

