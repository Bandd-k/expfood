//
//  CartController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 04.04.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import Parse

//simple delegate
protocol CartCellDelegate{
    func didDeleteItem()
}

class CartController: UIViewController,UITableViewDataSource, UITableViewDelegate,CartCellDelegate,UIWebViewDelegate {
    var instanceIdQuery: NSDictionary?
    weak var delegate:AddIntoCartDelegate?
    var instanceId: String?
    var pushed = 0
    @IBOutlet weak var MainTable: UITableView!
    var products:[(Product,Int)] = []
    var sum: Double = 0
    var minPrice = 200;
    override func viewDidLoad() {
        super.viewDidLoad()
        let mycart = Cart.sharedCart()
        products = mycart.products
        sum = CalculateSum()
        
        MakeOrderButton.frame.size.width = self.view.frame.size.width
        MainTable.frame.size.width = self.view.frame.size.width
        MakeOrderButton.titleLabel?.numberOfLines = 1;
        MakeOrderButton.titleLabel?.adjustsFontSizeToFitWidth = true
        MakeOrderButton.titleLabel?.minimumScaleFactor = 3
        MakeOrderButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByClipping
        if(products.count == 0){
            //MakeOrderButton.titleLabel?.textAlignment = NSTextAlignment.Center
            MakeOrderButton.setTitle("Добавьте товаров в корзину !", forState: UIControlState.Normal)
        }
        else if( sum < Double(minPrice) ){
            MakeOrderButton.setTitle("Минимальный заказ \(minPrice)р", forState: UIControlState.Normal)
        }
        //SendOrder()
        MakeOrderButton.setBackgroundImage(UIImage(named: "cartBackground.png"), forState: UIControlState.Normal)
        MakeOrderButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        sum = CalculateSum()
        self.pushed = 0
        if(self.pushed == 1){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.pushed = 0
        let defaults = NSUserDefaults.standardUserDefaults()
        var answer = defaults.boolForKey("PaySuccess")
        if(answer == true){//покупка успешна
            MakeOrderButton.setTitle("Добавьте товаров в корзину !", forState: UIControlState.Normal)
            SendOrder()
            let mycart = Cart.sharedCart()
            for ex in products {
                mycart.deleteFromCart(ex.0)
            }
            products = mycart.products
            MainTable.reloadData()
        }
        else{ //покупка Неуспешна
            var alert = UIAlertView(title: nil, message: "Упс:( Что-то пошло не так(", delegate: self, cancelButtonTitle: "Ок")
            alert.show()
        }
        }
        

    }
    @IBOutlet weak var MakeOrderButton: UIButton!
    //method calls when Pushed delete in cell
    func didDeleteItem() {
        delegate?.addProduct()
        let mycart = Cart.sharedCart()
        products = mycart.products
        sum = CalculateSum()
        MainTable.reloadData()
        if(products.count == 0 ){
        MakeOrderButton.setTitle("Добавьте товаров в корзину !", forState: UIControlState.Normal)
        }
        else if( sum < Double(minPrice) ){
            MakeOrderButton.setTitle("Минимальный заказ \(minPrice)р", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func SendOrder(){
        var order = PFObject(className:"Orders")
        var ids: [String] = []
        var relation = order.relationForKey("User")
        let user = PFUser.currentUser()
        relation.addObject(user!)
        var quantities: [Int] = []
        for elem in products{
            ids.append(elem.0.objectId)
            quantities.append(elem.1)
        }
        order["productsId"] = ids
        order["quantity"] = quantities
        order.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(false, forKey: "PaySuccess")
                var alert = UIAlertView(title: nil, message: "Спасибо за заказ!)", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                // The object has been saved.
            } else {
                var alert = UIAlertView(title: nil, message: "Упс:( Что-то пошло не так(", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                // There was a problem, check error.description
            }
        }
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    @IBOutlet weak var OrderButton: UIButton!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    func CalculateSum()->(Double){
        var sum: Double = 0
        let mycart = Cart.sharedCart()
        products = mycart.products
        for obj in products{
            sum += Double(obj.1) * obj.0.Price
        }
        return sum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "CartCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as! CartCell
            //let cell = tableView.cellForRowAtIndexPath(indexPath) as! CartCell
            // Configure the cell...
            cell.Name.text = products[indexPath.row].0.Name
            cell.Img!.kf_setImageWithURL(products[indexPath.row].0.imageUrl, placeholderImage: UIImage(named: "placeholder"))
            cell.ProdTuple = products[indexPath.row]
            cell.delegate = self
            var value = products[indexPath.row].0.Price * Double(products[indexPath.row].1)
            cell.quantity.text = "\(Int(products[indexPath.row].0.Price))р x \(products[indexPath.row].1) = \(value)₽"
            if(indexPath.row == products.count-1){//отобразить цену
                if(CalculateSum() > Double(minPrice)){
                MakeOrderButton.setTitle("Заказать на \(Int(sum))р", forState: UIControlState.Normal)
                }
                else{
                        MakeOrderButton.setTitle("Минимальный заказ \(minPrice)р", forState: UIControlState.Normal)
                }
            }
            return cell
    }

    
    @IBOutlet weak var Butt: UIButton!
    @IBAction func Order(sender: AnyObject) {
        self.pushed = 1
        if(products.count != 0 && CalculateSum() > Double(minPrice)) {
        //Яндекс Деньги !!
       // var mycntrl = YMACpsController(clientId: "1F666358D089A71E1F37577B366C184AF390FECC898C0397F29562ACAE0D5F8C",patternId: "p2p",andPaymentParams:["amount":"1","to" : "410013085842859"])
        //self.naPushViewController(mycntrl, animated: true, completion: nil)
           // PaySuccess
            
            
//        var cntrl = YMACpsViewController(clientId: "1F666358D089A71E1F37577B366C184AF390FECC898C0397F29562ACAE0D5F8C",patternId: "p2p",andPaymentParams:["amount":"\(self.sum+50)","to" : "410013085842859"])
//            self.navigationController?.pushViewController(cntrl, animated: true) // working code!
            let defaults = NSUserDefaults.standardUserDefaults()
                    if PFUser.currentUser() != nil
                    {
                        //let password = defaults.stringForKey("Password")
            performSegueWithIdentifier("toPrePaid", sender: nil)
            }
                    else{
                        performSegueWithIdentifier("toReg", sender: nil)
                        
            }
            
            
            //второй способ
            
            //register an instance of the application
//            var session = YMAExternalPaymentSession()
//            let defaults = NSUserDefaults.standardUserDefaults()
//            let currentInstanceId = defaults.stringForKey("currentInstanceId")
//            if (currentInstanceId == nil) {
//                session.instanceWithClientId("1F666358D089A71E1F37577B366C184AF390FECC898C0397F29562ACAE0D5F8C", token: nil, completion: { (instanceId, error) -> Void in
//                    if(error != nil){
//                        println("ERROR")
//                    }
//                    else{
//                        session.instanceId = instanceId
//                       defaults.setObject(instanceId, forKey: "currentInstanceId")
//                    }
//                })
//            }
//            else{
//               session.instanceId = currentInstanceId
//            }
//            var str:String = ""
//            //Request external payment
//            var externalPaymentRequest = YMAExternalPaymentRequest.externalPaymentWithPatternId("p2p", andPaymentParams: ["amount":sum,"to" : "410013085842859"])
//            session.performRequest(externalPaymentRequest, token: nil, completion: { (request, response, error) -> Void in
//                if (error != nil) {
//                    // Process error
//                    println("ERROR")
//                } else {
//                    str = (response as! YMAExternalPaymentResponse).paymentRequestInfo.requestId
//                    var externalPaymentResponse = response
//                }
//            })
//            //Process external payment
//            var processExternalPaymentRequest = YMAProcessExternalPaymentRequest.processExternalPaymentWithRequestId(str, successUri: "http://expfood.ru", failUri: "http://expfood.ru", requestToken: false)
//            
//            session.performRequest(processExternalPaymentRequest, token: nil, completion: { (request, response, error) -> Void in
//                if (error != nil) {
//                    println("error")
//                }
//                var processResponse = response as! YMABaseProcessResponse
//                
//                if (processResponse.status == YMAResponseStatus.InProgress) {
//                    // Process InProgress status
//                }
//                else if (processResponse.status == YMAResponseStatus.Success) {
//                    // Process Success status
//                }
//                else if (processResponse.status == YMAResponseStatus.ExtAuthRequired) {
//                    // Process AuthRequired status
//                }
//            })
//            
            
        }
        else{
            //var controlers = self.navigationController?.viewControllers
            //self.navigationController?.popToViewController(controlers![1] as! UIViewController, animated: true) - old
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        
            
        
    }
    
    
        //как было на хакатоне!//
//        var controlers = self.navigationController?.viewControllers
//        var alert = UIAlertController(title: "Готово!", message: "Ваш заказ принят", preferredStyle: UIAlertControllerStyle.Alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
//            switch action.style{
//            case .Default:
//                self.navigationController?.popToViewController(controlers![0] as UIViewController, animated: true)
//                
//            case .Cancel:
//                self.navigationController?.popToViewController(controlers![0] as UIViewController, animated: true)
//                
//            case .Destructive:
//                self.navigationController?.popToViewController(controlers![0] as UIViewController, animated: true)            }
//        }))
        
        
       // self.presentViewController(alert, animated: true, completion: nil)

        

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPrePaid" {
            let dest = segue.destinationViewController as! prePaidController
            var free = false
            if let currentUser = PFUser.currentUser() {
                if let f = currentUser["free"] as? Bool {// change
                free = f
                }
                
            }
            if(!free){
            dest.form.formRowWithTag("price")!.value = self.sum.description
            //dest.form.formRowWithTag("delivery")!.value = "50"
            dest.form.formRowWithTag("Sale")!.value = (self.sum * -0.05).description
            dest.form.formRowWithTag("sum")!.value = (self.sum * 0.95 + 100).description
            dest.sum = self.sum + 100
            dest.secondSum = self.sum * 0.95 + 100
            }
            else {
                dest.form.formRowWithTag("price")!.value = self.sum.description
                //dest.form.formRowWithTag("delivery")!.value = "50"
                dest.form.formRowWithTag("Sale")!.value = (self.sum * -0.05).description
                dest.form.formRowWithTag("sum")!.value = (self.sum * 0.95).description
                dest.sum = self.sum
                dest.secondSum = self.sum * 0.95
                
            }
        }
    }
    

}
