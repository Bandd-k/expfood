//
//  ProductsView.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import Parse
import Kingfisher

let reuseIdentifier = "Cell"



class ProductsView: UICollectionViewController,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UISearchBarDelegate,AddIntoCartDelegate {
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 30))
    var products:[Product] = []
    var filteredProducts:[Product] = []
    var searchActive : Bool = false
    var tp:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = tp
        //ParseLoadData()
        println("Hello")
        //set cell size
        var size = (self.view.bounds.width-8) / 3
        var test: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        test.itemSize =  CGSizeMake(size,size+100)
        // search controller
        navigationItem.rightBarButtonItem = BarButton()
        var rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchTapped")
        // 3
        //self.navigationItem.setRightBarButtonItems([self.navigationItem.rightBarButtonItem!,rightSearchBarButtonItem], animated: true)
        searchTapped()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        if Cart.sharedCart().ordered {
            self.collectionView?.reloadData()
            Cart.sharedCart().ordered = false
            navigationItem.rightBarButtonItem = BarButton()
        }
        //navigationItem.rightBarButtonItem = BarButton()
    }
    
    func BarButton()-> UIBarButtonItem{
        
        var but = UIButton(frame: CGRectMake(0, 0, 40, 40))
        but.addTarget(self, action: "performToCart", forControlEvents: UIControlEvents.TouchDown)
        var img = UIImage(named: "shopping-cart")
        but.setImage(img, forState: UIControlState.Normal)
        var navLeft = UIBarButtonItem(customView: but)
        navLeft.badgeValue = Cart.sharedCart().cartQuantity().description
        navLeft.badgeBGColor = UIColor.orangeColor()
        navLeft.badgePadding = 3
        navLeft.badgeOriginY = 5
        return navLeft
    }
    func performToCart(){
        self.performSegueWithIdentifier("toCart", sender: nil)
    }
    func searchTapped(){
        searchBar.placeholder = "Поиск"
        var leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.titleView = searchBar
        var textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        definesPresentationContext = true
        searchBar.delegate = self
        
        
    }
    func hint()->(){
        self.collectionView?.reloadSections(NSIndexSet(index: 0))
        self.collectionView?.performBatchUpdates(nil, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if searchActive {
          return filteredProducts.count
        }
        else{
          return products.count
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            //1
        if searchActive {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProdCell
            //let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProdCell
            //2 configurate
        cell.prod = filteredProducts[indexPath.row]
        cell.Image.kf_setImageWithURL(filteredProducts[indexPath.row].imageUrl, placeholderImage: UIImage(named: "placeholder"))
        cell.NameLabel.text = filteredProducts[indexPath.row].Name
        cell.PriceLabel.text = "\(Int(filteredProducts[indexPath.row].Price))руб - \(Double(filteredProducts[indexPath.row].weight))г"
        //cell.PriceLabel.text = "бр"
        let mycart = Cart.sharedCart()
        var index = mycart.In(filteredProducts[indexPath.row])
        if(index > -1){
            cell.QuantityImage.image = UIImage(named: "orange.png")
            cell.quantityLabel.text = "\(mycart.products[index].1)"
            cell.tuple = (filteredProducts[indexPath.row],mycart.products[index].1)
        }
        else{
            cell.QuantityImage.image = nil
            cell.quantityLabel.text = ""
            cell.tuple = (filteredProducts[indexPath.row],0)
        }
        //cell.Description.textColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
         //   102.0/255.0, alpha: 1)
            return cell
        } else {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProdCell
        //let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProdCell
        //2 configurate
        cell.prod = products[indexPath.row]
        cell.Image.kf_setImageWithURL(products[indexPath.row].imageUrl, placeholderImage: UIImage(named: "placeholder"))
        cell.NameLabel.text = products[indexPath.row].Name
        cell.PriceLabel.text = "\(Int(products[indexPath.row].Price))руб - \(Double(products[indexPath.row].weight))г"
        //cell.PriceLabel.text = "бр"
        let mycart = Cart.sharedCart()
        var index = mycart.In(products[indexPath.row])
        if(index > -1){
            cell.QuantityImage.image = UIImage(named: "orange.png")
            cell.quantityLabel.text = "\(mycart.products[index].1)"
            cell.tuple = (products[indexPath.row],mycart.products[index].1)
        }
        else{
            cell.QuantityImage.image = nil
            cell.quantityLabel.text = ""
            cell.tuple = (products[indexPath.row],0)
        }
        //cell.Description.textColor = UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
        //   102.0/255.0, alpha: 1)
        return cell
        }
        }
    
    private let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    /*
    Depricated
    
    
    func loadData(){
        let url = NSURL(string: "http://expfood-poisk.rhcloud.com/api/v1/product/?category__category_name=\(tp)&format=json")
        //let url =  NSURL(string: "http://um.mos.ru/api/houses.list.php")
        var request = NSURLRequest(URL: url!)
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if data != nil {
            var hoge = JSON(data: data!)
            if(hoge != nil){ // need add checking before unwrapping
                for element in hoge["objects"] {
                    //var t = element.1["image"]
                    //var finish = "http://expfood-poisk.rhcloud.com/\(t)"
                    var finish = "http://hleb4u.ru/published/publicdata/HLEB4U39WA/attachments/SC/products_pictures/Semmel%20mit%20Sesam_enl.jpg"
                    let pictUrl = NSURL(string: finish)
                    var Pictreq = NSURLRequest(URL: pictUrl!)
                   // var PictData = NSURLConnection.sendAsynchronousRequest(Pictreq, returningResponse: nil, error: nil)
                    var PictData: NSData?
                    NSURLConnection.sendAsynchronousRequest(Pictreq, queue: NSOperationQueue(), completionHandler: { (response, data, error) -> Void in
                        PictData = data
                    })
                    var str = element.1["product_name"].string!
                    var prc = element.1["price"].doubleValue
                    var moreID = element.1["id"].int!
                    var anotherProd = Product(name: str, price: prc, image: UIImage(data: PictData!)!, id: "\(moreID)")
                    products.append(anotherProd)
                    
                    
                }
            }
        }
        
        
    }
    
    func ParseLoadData(){
        var query = PFQuery(className:"products")
        query.whereKey("category", equalTo: tp)
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
                        self.products.append(anotherProd)
                    }
                    //self.collectionView?.reloadData()
                }
            }
        }
        
    }
     */
        
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchActive = false
        if segue.identifier == "fromCell"{ // adjusting segue
             if let indexPath = self.collectionView?.indexPathForCell(sender as! UICollectionViewCell){
                let destinationController = segue.destinationViewController as! OneProductViewController
                destinationController.Prod = (sender as! ProdCell).tuple
                destinationController.delegate = self
                
            }
            
        }else if segue.identifier == "toCart" {
            let destinationController = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! CartController
            destinationController.delegate = self
        }
    }
    
    func addProduct(){
        navigationItem.rightBarButtonItem = BarButton()
        self.collectionView?.reloadData()
    }
    
    // SearchDelegate
    func filterContentForSearchText(searchText: String) {
        filteredProducts = products.filter({ ( product: Product) -> Bool in
        let nameMatch = product.Name.rangeOfString(searchText, options:
            NSStringCompareOptions.CaseInsensitiveSearch)
        return nameMatch != nil
        })
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchActive = true;
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = products.filter({ ( product: Product) -> Bool in
            let nameMatch = product.Name.rangeOfString(searchText, options:
                NSStringCompareOptions.CaseInsensitiveSearch)
            return nameMatch != nil
        })
        if(searchText == ""){
            searchBar.resignFirstResponder()
            delay(0.001, { () -> () in
                self.searchActive = false
                searchBar.resignFirstResponder()
                self.collectionView?.reloadData()
            })
            searchActive = false
        } else {
            searchActive = true
            self.collectionView?.reloadData()
        }
    }
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        searchActive = false;
        return true
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
