//
//  PayController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 05.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
class PayController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Pay(sender: AnyObject) {
        let mycart = Cart.sharedCart()
        var idMass :[String] = []
        var str = "products="
        for elem in mycart.products{
            str = str + "\(elem.0.Id),"
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://95.85.16.63:8080/ExpFood%5Fwar/orders/add")!)
        request.HTTPMethod = "POST"
        var mas = [1048,2666]
        let postString = "id=\(mas)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
