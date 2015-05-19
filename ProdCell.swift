//
//  ProdCell.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 08.05.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit

class ProdCell: UICollectionViewCell {
    var prod: Product?
    var tuple: (Product,Int)?
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var QuantityImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
}
