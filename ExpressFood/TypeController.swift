//
//  TypeController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import Parse
class TypeController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var products:[Product] = []
    var pushed: Bool = false
    var Types = [Type2(Name: "Фрукты и овощи", Image: "type1.png", Id: "FruitAndVegetables"),Type2(Name: "Мясо и рыба", Image: "type2.png", Id: "meat"),Type2(Name: "Выпечка", Image: "type4.png", Id: "Bakery"),Type2(Name: "Алкоголь", Image: "type5.png", Id: "alcohol"),Type2(Name: "Молочная продукция", Image: "type6.png", Id: "dairy"),Type2(Name: "Консервы", Image: "type7.png", Id: "cannedFoods"),Type2(Name: "Напитки", Image: "type8.png", Id: "Drinks"),Type2(Name: "Снеки", Image: "type10.png", Id: "Snacks"),Type2(Name: "Полуфабрикаты", Image: "type11.png",Id:"prepack" ),Type2(Name: "Бытовые", Image: "type12.png", Id: "household"),Type2(Name: "Бакалея", Image: "type14.png", Id: "Grocery"),Type2(Name: "Кондитерские изделия", Image: "type15.png", Id: "confection")]
    var data: [[Product]] = [];
    //Type2(Name: "Корма", Image: "type13.png", Id: "Fooders") is deleted
    // Type2(Name: "Деликатесы", Image: "type3.png", Id: "Delicacies") is deleted
    // Type3 Type2(Name: "Завтраки", Image: "type9.png", Id: "Breakfast") is deleted
    
    @IBOutlet weak var MainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for obj in Types{
            var timing:[Product] = []
            data.append(timing)
        }
        SVProgressHUD.setBackgroundColor(UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 0))
        SVProgressHUD.setForegroundColor(UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 1))
        SVProgressHUD.setRingThickness(6)
        MainTable.delegate = self
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "icon_trans.png"))

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        pushed = false
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Types.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(pushed != true){
            pushed = true
            if(self.data[indexPath.row].count < 1){
                    
                SVProgressHUD.show()
        self.products = []
        var queryt = PFQuery(className:"products")
        queryt.whereKey("category", equalTo:self.Types[indexPath.row].id )
        queryt.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var finish = object["product_img"] as! String
                        let pictUrl = NSURL(string: finish)
                        var Pictreq = NSURLRequest(URL: pictUrl!)
                        var PictData = NSURLConnection.sendSynchronousRequest(Pictreq, returningResponse: nil, error: nil)
                        var str = object["product_name"] as! String
                        var prc = object["price"] as! Double
                        var moreID = object["id"] as! Int
                        var anotherProd = Product(name: str, price: prc, image: UIImage(data: PictData!)!, id: "\(moreID)")
                        anotherProd.objectId = object.objectId!
                        anotherProd.Description = object["description"] as! String
                        let numberOfPlaces = 2.0
                        let multiplier = pow(10.0, numberOfPlaces)
                        let num = object["weight"] as! Double
                        let rounded = round(num * multiplier) / multiplier
                        anotherProd.weight = rounded
                        self.products.append(anotherProd)
                    }
                    self.data[indexPath.row] = self.products
                    SVProgressHUD.dismiss()
                    self.performSegueWithIdentifier("TableSegue", sender: nil)
                    
                    //self.collectionView?.reloadData()
                }
            }
        }
            }
            else{
                self.performSegueWithIdentifier("TableSegue", sender: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "TypeCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:
                indexPath) as! CellForType
            // Configure the cell...
            cell.TypeName.text = Types[indexPath.row].name
            cell.TypeBackground.image = Types[indexPath.row].image
            
            return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "TableSegue" {
            if let indexPath = self.MainTable.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! ProductsView
                destinationController.tp = Types[indexPath.row].name
                destinationController.products = data[indexPath.row]
                //destinationController.ParseLoadData()
                
            }
        }
    }
    
    func ParseLoadData(tp : String){
        self.products = []
        var query = PFQuery(className:"products")
        query.whereKey("category", equalTo:tp )
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var finish = object["product_img"] as! String
                        let pictUrl = NSURL(string: finish)
                        var Pictreq = NSURLRequest(URL: pictUrl!)
                        var PictData = NSURLConnection.sendSynchronousRequest(Pictreq, returningResponse: nil, error: nil)
                        var str = object["product_name"] as! String
                        var prc = object["price"] as! Double
                        var moreID = object["id"] as! Int
                        var anotherProd = Product(name: str, price: prc, image: UIImage(data: PictData!)!, id: "\(moreID)")
                        anotherProd.objectId = object.objectId!
                        self.products.append(anotherProd)
                    }
                    
                    //self.collectionView?.reloadData()
                }
            }
        }

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
