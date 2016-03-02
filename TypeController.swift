//
//  TypeController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import Parse
class TypeController: UIViewController,UITableViewDataSource, UITableViewDelegate,GHWalkThroughViewDataSource {
    var imageView: UIImageView = UIImageView(image: UIImage(named: "222"))
    var products:[Product] = []
    var ghView:GHWalkThroughView?
    var pushed: Bool = false
    var chg:Bool = false
//    var Types = [Type2(Name: "Фрукты и овощи", Image: "type1.png", Id: "FruitAndVegetables"),Type2(Name: "Мясо и рыба", Image: "type2.png", Id: "meat"),Type2(Name: "Выпечка", Image: "type4.png", Id: "Bakery"),Type2(Name: "Алкоголь", Image: "type5.png", Id: "alcohol"),Type2(Name: "Молочная продукция", Image: "type6.png", Id: "dairy"),Type2(Name: "Консервы", Image: "type7.png", Id: "cannedFoods"),Type2(Name: "Напитки", Image: "type8.png", Id: "Drinks"),Type2(Name: "Снеки", Image: "type10.png", Id: "Snacks"),Type2(Name: "Полуфабрикаты", Image: "type11.png",Id:"prepack" ),Type2(Name: "Бытовые", Image: "type12.png", Id: "household"),Type2(Name: "Бакалея", Image: "type14.png", Id: "Grocery"),Type2(Name: "Кондитерские изделия", Image: "type15.png", Id: "choco")]
    var Types = [Type2(Name: "Фрукты и овощи", Image: "fruits.png", Id: "fruits"),Type2(Name: "Соки", Image: "juices.png", Id: "juices"),Type2(Name: "Напитки", Image: "water.png", Id: "water"),Type2(Name: "Завтраки и чипсы", Image: "breakfasts.png", Id: "breakfasts"),Type2(Name: "Творог и йогурты", Image: "curd", Id: "curd"),Type2(Name: "Молочная продукция", Image: "dairy.png", Id: "dairy"),Type2(Name: "Сыры", Image: "cheese.png", Id: "cheese"),Type2(Name: "Мясные деликатесы", Image: "meatdeli.png", Id: "meatdeli"),Type2(Name: "Мясо", Image: "meat.png",Id:"meat" ),Type2(Name: "Рыба", Image: "fish.png", Id: "fish"),Type2(Name: "Хлеб", Image: "bread.png", Id: "bread"),Type2(Name: "Макароны и крупы", Image: "pasta.png", Id: "pasta"),Type2(Name: "Кулинария", Image: "cooked.png", Id: "cooked"),Type2(Name: "Шоколад", Image: "choco.png", Id: "choco"),Type2(Name: "Печенье", Image: "cookies.png", Id: "cookies"),Type2(Name: "Сладости", Image: "sweet.png", Id: "sweet"),Type2(Name: "Замороженные продукты", Image: "frozen.png", Id: "frozen"),Type2(Name: "Консервы", Image: "canned.png", Id: "canned"),Type2(Name: "Чай и кофе", Image: "tea.png", Id: "tea"),Type2(Name: "Соусы", Image: "sauces.png", Id: "sauces"),Type2(Name: "Соль и специи", Image: "salt.png",Id:"salt" ),Type2(Name: "Орехи и масла", Image: "nuts.png", Id: "nuts"),Type2(Name: "Детское питание", Image: "baby.png", Id: "baby")]
    var data: [[Product]] = [];
    
    let textes = ["Тысячи свежих товаров из Азбуки Вкуса у Вас в телефоне","Наш курьер за час доставит продукты к двери Вашего дома","Подарок от нас, первая доставка за наш счет!"]
    //confection change on choco
    //Type2(Name: "Корма", Image: "type13.png", Id: "Fooders") is deleted
    // Type2(Name: "Деликатесы", Image: "type3.png", Id: "Delicacies") is deleted
    // Type3 Type2(Name: "Завтраки", Image: "type9.png", Id: "Breakfast") is deleted
    
    @IBOutlet weak var MainTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        for obj in Types{
            let timing:[Product] = []
            data.append(timing)
        }
        SVProgressHUD.setBackgroundColor(UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 0))
        SVProgressHUD.setForegroundColor(UIColor(red: 102.0/255.0, green: 204.0/255.0, blue:
            102.0/255.0, alpha: 1))
        SVProgressHUD.setRingThickness(6)
        MainTable.delegate = self
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "icon_trans.png"))
        
        
        //walkthrough
        let defaults = NSUserDefaults.standardUserDefaults()
        let password = defaults.boolForKey("Walk")
        if(password){
            defaults.setBool(true, forKey: "Walk")
        ghView = GHWalkThroughView(frame: self.navigationController!.view.bounds)
        ghView!.dataSource = self
        ghView?.isfixedBackground = false
        ghView?.showInView(self.navigationController!.view, animateDuration: 0.2)
        ghView?.walkThroughDirection = GHWalkThroughViewDirection.Horizontal
        }
        //[_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
        
        //customizin Bounces
        self.MainTable.backgroundColor = UIColor.clearColor()
        
        self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        
        let tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0));
        tableHeaderView.backgroundColor = UIColor.purpleColor()
        tableHeaderView.addSubview(self.imageView)
        self.MainTable.tableHeaderView = tableHeaderView

        
        

        // Do any additional setup after loading the view.
    }
    
    //bounces
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        //print(yPos)
        if(yPos < CGFloat(-95.0)&&chg){
            chg = false
            let diceRoll = Int(arc4random_uniform(4))
            //print(yPos)
            if(diceRoll==0||diceRoll==3){
                self.imageView = UIImageView(image: UIImage(named: "111"))
                
            }else if(diceRoll==1){
                self.imageView = UIImageView(image: UIImage(named: "222"))
                
            }else{
                self.imageView = UIImageView(image: UIImage(named: "333"))
            }
            self.imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)
            self.imageView.contentMode = .ScaleAspectFill
            self.imageView.clipsToBounds = true
            
            let tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0));
            tableHeaderView.backgroundColor = UIColor.purpleColor()
            tableHeaderView.addSubview(self.imageView)
            self.MainTable.tableHeaderView = tableHeaderView

        }
        else{
            chg = true
        }
        if (yPos > 0) {
            var imgRect: CGRect = self.imageView.frame
            imgRect.origin.y = -20 - yPos/2
            imgRect.size.height = 20+yPos/2
            if(imgRect.size.height >= 90){
                imgRect.size.height = 90
            }
            self.imageView.frame = imgRect
        }
    }

    //walkthrough DATASource 
    
    func numberOfPages() -> Int {
        return 3;
        
    }
    
    func configurePage(cell: GHWalkThroughPageCell!, atIndex index: Int) {
        cell.desc = self.textes[index]
        //cell.desc = "крутой экспфуд) супер крутые фичи тут)"
        
    }
    func bgImageforPage(index: Int) -> UIImage! {
        return UIImage(named: "\(index+1).jpg")
    }
    

    
    override func viewWillAppear(animated: Bool) {
        pushed = false
        navigationItem.rightBarButtonItem = BarButton()
    }
    func BarButton()-> UIBarButtonItem{
        
        let but = UIButton(frame: CGRectMake(0, 0, 40, 40))
        but.addTarget(self, action: "performToCart", forControlEvents: UIControlEvents.TouchDown)
        let img = UIImage(named: "shopping-cart")
        but.setImage(img, forState: UIControlState.Normal)
        let navLeft = UIBarButtonItem(customView: but)
        navLeft.badgeValue = Cart.sharedCart().cartQuantity().description
        navLeft.badgeBGColor = UIColor.orangeColor()
        navLeft.badgePadding = 3
        navLeft.badgeOriginY = 5
        return navLeft
    }
    func performToCart(){
        self.performSegueWithIdentifier("toCart", sender: nil)
        
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
        let mycart = Cart.sharedCart()
        if(mycart.internet==false){
            let alert = UIAlertView(title: "Отсутсвует соединение с интернетом", message: "Невозможно продолжить работу", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            if Reachability.isConnectedToNetwork() == true {
                mycart.internet = true
            }
            
        }
        else{
        if(pushed != true){
            pushed = true
            if(self.data[indexPath.row].count < 1){
                SVProgressHUD.show()
        self.products = []
        let queryt = PFQuery(className:"prodIOS")
        queryt.limit = 700
        queryt.skip = 0
        queryt.orderByAscending("createdAt")
        queryt.whereKey("category", equalTo:self.Types[indexPath.row].id )
        queryt.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let finish = object["img_sm"] as! String // product_img -> img_sm
                        let pictUrl = NSURL(string: finish)
                        let str = object["product_name"] as! String
                        let prc = object["price"] as! Double
                        let anotherProd = Product(name: str, price: prc, ImageUrl: pictUrl!, id: object.objectId!)
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
            }//
            else{
                self.performSegueWithIdentifier("TableSegue", sender: nil)
            }
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
            if let indexPath = self.MainTable.indexPathForSelectedRow {
                let destinationController = segue.destinationViewController as! ProductsView
                destinationController.tp = Types[indexPath.row].name
                destinationController.products = data[indexPath.row]
                //destinationController.ParseLoadData()
                
            }
        }
    }
    
    func ParseLoadData(tp : String){
        self.products = []
        let query = PFQuery(className:"products")
        query.whereKey("category", equalTo:tp )
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        let finish = object["product_img"] as! String
                        let pictUrl = NSURL(string: finish)
                        let Pictreq = NSURLRequest(URL: pictUrl!)
                        var PictData = try? NSURLConnection.sendSynchronousRequest(Pictreq, returningResponse: nil)
                        let str = object["product_name"] as! String
                        let prc = object["price"] as! Double
                        let moreID = object["id"] as! Int
                        let anotherProd = Product(name: str, price: prc, ImageUrl: pictUrl!, id: "\(moreID)")
                        anotherProd.objectId = object.objectId!
                        self.products.append(anotherProd)
                    }
                    
                    //self.collectionView?.reloadData()
                }
            }
        }

    }
    
    @IBAction func pushInfo(sender: AnyObject) {
        Helpshift.sharedInstance().showFAQs(self, withOptions: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
