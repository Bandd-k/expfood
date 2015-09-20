//
//  OneProductViewController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 09.05.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
protocol AddIntoCartDelegate: NSObjectProtocol {
    func addProduct()
}

class OneProductViewController: UIViewController {
    var Prod: (Product,Int)?
    var quantity: Int = 0
    weak var delegate:AddIntoCartDelegate?
    @IBOutlet weak var ToCatButton: UIButton!
    @IBOutlet weak var DescriptionLabel: UITextView!
    @IBOutlet weak var PriceLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProductImage: UIImageView!
    @IBOutlet weak var quantityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        quantity = Prod!.1
        quantityLabel.text = "\(quantity)"
        PriceLabel.text = "\(Prod!.0.Price)руб"
        NameLabel.text = Prod?.0.Name
        ProductImage.kf_setImageWithURL(Prod!.0.imageUrl, placeholderImage: UIImage(named: "placeholder"))
        if(count(Prod!.0.Description) > 2){
        DescriptionLabel.text = Prod!.0.Description
        }
        else{
            DescriptionLabel.text = "Описание отсутсвует :("
        }
        DescriptionLabel.contentOffset = CGPointMake(0, -220)
        if(quantity>0){
            ToCatButton.setBackgroundImage(UIImage(named:"changeQuantity.png"), forState: UIControlState.Normal)
        }else{
            quantity = 1
            quantityLabel.text = "\(quantity)"
            ToCatButton.setBackgroundImage(UIImage(named:"addProduct.png"), forState: UIControlState.Normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func toCartPush(sender: AnyObject) {
        let mycart = Cart.sharedCart()
        mycart.addTocart(Prod!.0, quantity: quantity)
        delegate?.addProduct()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func MinusPush(sender: AnyObject) {
        if(quantity > 0){
        quantity -= 1
        quantityLabel.text = "\(quantity)"
        }
    }

    @IBAction func PlusPush(sender: AnyObject) {
        quantity += 1
        quantityLabel.text = "\(quantity)"
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
