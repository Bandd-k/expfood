//
//  CartCell.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit


class CartCell: UITableViewCell {
var ProdTuple: (Product,Int)!
var delegate : CartCellDelegate? //delegate to work with table
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Name.textColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 1)
        quantity.textColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 1)
        DeleteButton.setTitleColor(UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 1), forState: UIControlState.Normal)
        DeleteButton.setImage(UIImage(named: "delete.png")?.imageWithRenderingMode(.AlwaysTemplate), forState: UIControlState.Normal)
        DeleteButton.tintColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 1)
        
    }

    @IBAction func PushDelete(sender: AnyObject) {
        let mycart = Cart.sharedCart()
        mycart.deleteFromCart(ProdTuple.0)
        delegate?.didDeleteItem()
    }
    @IBOutlet weak var Img: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
