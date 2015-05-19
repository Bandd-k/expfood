//
//  Cart.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import Foundation
import Parse

class Cart: NSObject {// singleton
    var user : PFUser?
    var internet : Bool = true
    var products: [(Product,Int)] = []
    class func sharedCart() -> Cart {
        return _sharedCart
    }
    
    func addTocart(Prod: Product, quantity: Int){
        deleteFromCart(Prod)
        if(quantity>0){
        products.append((Prod,quantity))
        }
    }
    func deleteFromCart(Prod: Product){
        for (index,elem) in enumerate(products){
            if(elem.0.Id == Prod.Id){
                products.removeAtIndex(index)
            }
        }
    }
    func In(Prod: Product) ->Int{
        for (index,elem) in enumerate(products){
            if(elem.0.Id == Prod.Id){
                return index
            }
        }
        return -1
    }
    
}
let _sharedCart : Cart = { Cart() }()