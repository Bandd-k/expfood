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
    var ordered: Bool = false
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
        for (index,elem) in products.enumerate(){
            if(elem.0.objectId == Prod.objectId){
                products.removeAtIndex(index)
            }
        }
    }
    func In(Prod: Product) ->Int{
        for (index,elem) in products.enumerate(){
            if(elem.0.objectId == Prod.objectId){
                return index
            }
        }
        return -1
    }
    func cartQuantity() -> Int {
        var sum = 0
        for elem in products {
            sum += elem.1
        }
        return sum
    }
    func cartSum() -> Double {
        var sum:Double = 0;
        for elem in products{
            sum += elem.0.Price * Double(elem.1)
        }
        return sum
    }
    func deleteAll(){
        products = []
    }
    
}
let _sharedCart : Cart = { Cart() }()