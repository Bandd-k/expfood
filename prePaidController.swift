//
//  prePaidController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 01.08.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import XLForm
import MapKit
import Parse

class prePaidController: XLFormViewController {
    var sum: Double = 350
    var secondSum: Double = 350
    var delivery: Double = 100
    var radius: CLLocationDistance = 4720
    var hour = 0
    var minutes = 0
    var pushed = 0
    var xcord = 55.7505
    var ycord = 37.619
    private enum Tags : String {
        case ValidationName = "Name"
        case ValidationEmail = "Email"
        case ValidationPassword = "Password"
        case ValidationInteger = "Integer"
        case AccessoryViewNotes = "notes"
        case HideRow = "hide"
        case Phone = "phone"
        case Price = "price"
        case SegmentedControl = "type"
        case ValidationStreet = "Street"
        case ValidationHouse = "House"
        case ValidationFlat = "Flat"
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    func initializeForm() {
        var street = ""
        var house = ""
        var flat = ""
        var free = false;
        sum = Cart.sharedCart().cartSum()
        if let currentUser = PFUser.currentUser() {
            if let st = currentUser["Street"] as? String{
                street = st
            }
            else if let t =  currentUser["AdressField"] as? String {
                street = deelPart(t)
            }
        house = currentUser["house"] as! String
        flat = currentUser["flat"] as! String
            if let fr = currentUser["free"] as? Bool {
                free = fr
            }
        }

        //self.view.tintColor = UIColor.orangeColor()
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Проверка Данных")
        
        
        
        // start Address section
        section = XLFormSectionDescriptor()
        section.title = "Address"
        form.addFormSection(section)
        // Street
        row = XLFormRowDescriptor(tag: "Street", rowType: XLFormRowDescriptorTypeText, title:"Улица")
        row.cellConfigAtConfigure["textField.placeholder"] = "Арбат"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        row.value = street
        section.addFormRow(row)
        // home
        row = XLFormRowDescriptor(tag: "House", rowType: XLFormRowDescriptorTypeText, title:"Дом")
        row.cellConfigAtConfigure["textField.placeholder"] = "25"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        row.value = house
        section.addFormRow(row)
        
        // Flat
        row = XLFormRowDescriptor(tag: "Flat", rowType: XLFormRowDescriptorTypeDecimal, title:"Квартира")
        row.cellConfigAtConfigure["textField.placeholder"] = "37"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.value = flat
        row.required = true
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        // Notes
        row = XLFormRowDescriptor(tag: "notes", rowType:XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "Дополнительные инструкции"
        section.addFormRow(row)
        
        
        //Pay Section
        
        
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        section.title = "Оплата"
        if (sum > 3000){
            section.footerTitle = "Скидка 5% при оплате картой, при заказе дороже 3 тысяч оплата только картой"
        }
        else{
        section.footerTitle = "Скидка 5% при оплате картой"
        }
        
        row = XLFormRowDescriptor(tag: Tags.SegmentedControl.rawValue, rowType: XLFormRowDescriptorTypeSelectorSegmentedControl, title: "Оплата")
        row.selectorOptions = ["карта","наличные"]
        row.value = "карта"
        section.addFormRow(row)
        if (sum > 3000){
            row.disabled = true
        }
        
        row = XLFormRowDescriptor(tag: Tags.Price.rawValue, rowType: XLFormRowDescriptorTypeText, title:"Стоимость Товаров")
        row.cellConfigAtConfigure["textField.placeholder"] = "1000"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.value = sum.description
        row.disabled = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "delivery", rowType: XLFormRowDescriptorTypeText, title:"Стоимость Доставки")
        row.cellConfigAtConfigure["textField.placeholder"] = "100"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        if(!free){
        row.value = delivery.description
        }
        else{
            row.value = "Бесплатно"
        }
        row.disabled = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: "Sale", rowType: XLFormRowDescriptorTypeText, title:"Скидка")
        row.cellConfigAtConfigure["textField.placeholder"] = "100"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.disabled = true
        row.hidden = "$\(Tags.SegmentedControl.rawValue).value == 'наличные'"
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: "sum", rowType: XLFormRowDescriptorTypeText, title:"Итого")
        row.cellConfigAtConfigure["textField.placeholder"] = "8100"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.value =  (sum + delivery).description
        row.disabled = true
        section.addFormRow(row)
        // time
        row = XLFormRowDescriptor(tag: "time", rowType: XLFormRowDescriptorTypeText, title:"Время доставки")
        row.cellConfigAtConfigure["textField.placeholder"] = "8100"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        hour = components.hour
        minutes = components.minute
        if hour < 22 && hour > 10 {
        row.value = (hour+1).description + ":" + minutes.description
        }
        else {
            row.value = "11:00"
        }
        row.disabled = true
        section.addFormRow(row)
        var timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateTime"), userInfo: nil, repeats: true)

        // button
        section = XLFormSectionDescriptor()
                form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "reg", rowType: XLFormRowDescriptorTypeButton, title: "Купить")
        row.cellConfig["textLabel.textColor"] = UIColor.appColor()
        row.action.formSelector = "reg:"
        section.addFormRow(row)
        
        
        
        
        
        
        
        
        self.form = form
        
        
    }
    func updateTime(){
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hourNow = components.hour
        let minutesNow = components.minute
        if minutesNow != minutes {
            hour = hourNow
            minutes = minutesNow
            if hourNow < 22 && hourNow > 10 {
            self.form.formRowWithTag("time")!.value = (hourNow+1).description + ":" + minutesNow.description
            }
            else {
                self.form.formRowWithTag("time")!.value = "11:00"
            }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form.delegate = self
        let query = PFQuery(className:"Radius")
        query.getObjectInBackgroundWithId("qiFXPpdUA1") {
            (object: PFObject?, error: NSError?) -> Void in
            if object != nil {
                if((object!["Value"] as? CLLocationDistance) != nil){
                    self.radius = object!["Value"] as! CLLocationDistance
                }
                if((object!["xCord"] as? Double) != nil){
                    self.xcord = object!["xCord"] as! Double
                }
                if((object!["yCord"] as? Double) != nil){
                    self.ycord = object!["yCord"] as! Double
                }
                
            } else {
                print(error)
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        if(self.pushed == 1){
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.pushed = 0
            let defaults = NSUserDefaults.standardUserDefaults()
            let answer = defaults.boolForKey("PaySuccess")
            if(answer == true){//покупка успешна
                SendOrder("true")

            }
            else{ //покупка Неуспешна
                let alert = UIAlertView(title: nil, message: "Заказ не сделан", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
            }
        }

    }
    
    func reg(sender: XLFormRowDescriptor)->(){
        if validate(){
            let str = self.form.formRowWithTag("Street")!.value as? String!
            let str1 = self.form.formRowWithTag("House")!.value as? String!
            let final = "Москва " + str! + " " + str1!
            checkAddress(final)
        }
        self.deselectFormRow(sender)
    }
    func SignUp(){ //registration PArse.COM and saving Defaults !
        let defaults = NSUserDefaults.standardUserDefaults()
        let user = PFUser()
        user.username = self.form.formRowWithTag("Email")!.value as? String
        user.password = self.form.formRowWithTag("Password")!.value as? String
        user.email = self.form.formRowWithTag("Email")!.value as? String
        // other fields can be set just like with PFObject
        user["phone"] = self.form.formRowWithTag("Phone")!.value as? String
        user["FirstName"] = self.form.formRowWithTag("Name")!.value as? String
        user["Street"] = self.form.formRowWithTag("Street")!.value as? String
        user["house"] = self.form.formRowWithTag("House")!.value as? String
        user["flat"] = (self.form.formRowWithTag("Flat")!.value as? Int)?.description
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                let alert = UIAlertView(title: nil, message: "Упс:( \(errorString!)", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                // Show the errorString somewhere and let the user try again.
            } else {
                defaults.setObject("\(user.username)", forKey: "Name")
                defaults.setObject("\(user.password)", forKey: "Password")
                var str = self.form.formRowWithTag("Street")!.value as? String!
                defaults.setObject("\(str)", forKey: "Street")
                str = self.form.formRowWithTag("House")!.value as? String!
                defaults.setObject("\(str)", forKey: "House")
                str = self.form.formRowWithTag("Flat")!.value as? String!
                defaults.setObject("\(str)", forKey: "Flat")
                self.dismissViewControllerAnimated(true, completion: nil)
                //self.performSegueWithIdentifier("Logged", sender: nil)
                // Hooray! Let them use the app now.
            }
        }
        
        
    }
    
    func checkAddress(adress:String)->Bool{
        var bl:Bool = true
        var localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = adress
        var localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            let fullNameArr = adress.componentsSeparatedByString(" ")
            if(fullNameArr.count > 2) {
                if localSearchResponse == nil{
                    var alert = UIAlertView(title: nil, message: "Адрес не найден", delegate: self, cancelButtonTitle: "Попробуйте еще раз")
                    alert.show()
                    bl = false
                    return
                }
                let DeliveryCordinates = CLLocation(latitude: self.xcord, longitude: self.ycord)
                print(localSearchResponse!.boundingRegion.center.latitude)
                print(localSearchResponse!.boundingRegion.center.longitude)
                let Home = CLLocation(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
                if(DeliveryCordinates.distanceFromLocation(Home) > self.radius){
                    var alert = UIAlertView(title: nil, message: "К сожалению мы еще не работаем здесь ;(;(", delegate: self, cancelButtonTitle: "Ок")
                    alert.show()
                    bl = false
                    if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1)) {
                        cell.backgroundColor = UIColor.orangeColor()
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.backgroundColor = UIColor.whiteColor()
                        })
                    }
                    if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) {
                        cell.backgroundColor = UIColor.orangeColor()
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.backgroundColor = UIColor.whiteColor()
                        })
                    }
                    if let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1)) {
                        cell.backgroundColor = UIColor.orangeColor()
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.backgroundColor = UIColor.whiteColor()
                        })
                    }
                }
                else {
                    //обновляем данные юзера
                    if let user = PFUser.currentUser() {
                        user["Street"] = self.form.formRowWithTag("Street")!.value as? String!
                        user["house"] = self.form.formRowWithTag("House")!.value as? String!
                        if let str = self.form.formRowWithTag("Flat")!.value as? String {
                        user["flat"] = str
                        }
                        else {
                            user["flat"] = (self.form.formRowWithTag("Flat")!.value as? Int)!.description
                        }
                        user.saveInBackground()
                        self.pushed = 1
                        if self.form.formRowWithTag(Tags.SegmentedControl.rawValue)!.value as? String  == "карта" {
                            var strr = self.form.formRowWithTag("sum")!.value as! String

                        var cntrl = YMACpsViewController(clientId: "1F666358D089A71E1F37577B366C184AF390FECC898C0397F29562ACAE0D5F8C",patternId: "p2p",andPaymentParams:["amount": self.newStr(strr) ,"to" : "410013085842859"])
                                    self.navigationController?.pushViewController(cntrl, animated: true)
                        }
                        else{
                            self.pushed = 0
                            self.SendOrder("false")
                            
                        }
                        // Делаем заказ
                    }
                    
                    
                }
            }
        }
        return bl
    }
    func newStr(a:String)->String{
        var flag = false
        var num=0
        var new = a
        let DotMark: Character = "."
        for i in a.characters{
            if( i == DotMark){
                flag = true
            }
            if(flag){
                num++;
            }
        }
        num-=2;
        while(num>1){
            new.removeAtIndex(new.endIndex.predecessor())
            num--
        }
        return new
    }
    func validate()->Bool{
        var bl:Bool = true
        let array = self.formValidationErrors()
        for errorItem in array {
            bl = false
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo[XLValidationStatusErrorKey] as! XLFormValidationStatus
            if
                validationStatus.rowDescriptor!.tag == Tags.ValidationStreet.rawValue ||
                validationStatus.rowDescriptor!.tag == Tags.ValidationHouse.rawValue ||
                validationStatus.rowDescriptor!.tag == Tags.ValidationFlat.rawValue
            {
                //                    if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)!) {
                //                        self.animateCell(cell)
                //                    }
                if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor!)!) {
                    cell.backgroundColor = UIColor.orangeColor()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.backgroundColor = UIColor.whiteColor()
                    })
                }
            }
        }
        return bl
        
    }
    
    func SendOrder(s:String){
        
        let order = PFObject(className:"Orders")
        var ids: [String] = []
        let relation = order.relationForKey("User")
        let user = PFUser.currentUser()
        relation.addObject(user!)
        var quantities: [Int] = []
        let mycart = Cart.sharedCart()
        let products = mycart.products
        for elem in products{
            ids.append(elem.0.objectId)
            quantities.append(elem.1)
        }
        order["paid"] = s
        order["productsId"] = ids
        order["quantity"] = quantities
        let strr = self.form.formRowWithTag("sum")!.value as! String
        order["sum"] = strr
        if self.form.formRowWithTag("notes")?.value != nil {
        order["notes"] = self.form.formRowWithTag("notes")!.value as? String
        }
        PFCloud.callFunctionInBackground("SMS", withParameters: ["number" : "+79851480904"])
        order.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                if let user = PFUser.currentUser() {
                    user["free"] = false
                    user.saveInBackground()
                }
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(false, forKey: "PaySuccess")
                let alert = UIAlertView(title: nil, message: "Спасибо за заказ!)", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                Cart.sharedCart().deleteAll()
                Cart.sharedCart().ordered = true
                self.dismissViewControllerAnimated(true, completion: nil)
                // The object has been saved.
            } else {
                let alert = UIAlertView(title: nil, message: "Заказ не сделан", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                // There was a problem, check error.description
            }
        }
        
        
        
        
    }

    
    
    //MARK: Actions
    
    //DELEGATe
    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
        if formRow.tag == Tags.SegmentedControl.rawValue {
            if newValue as! String == "карта" {
                form.formRowWithTag("sum")!.value = secondSum.description
                self.tableView.reloadData()
        }
            else {
                form.formRowWithTag("sum")!.value = sum.description
                self.tableView.reloadData()
            }
        }
    }

    
    //MARK: - Helperph
    
    func deelPart(str:String)->String{
        let fullNameArr = str.componentsSeparatedByString(",")
        return fullNameArr[0]
    }
    
    func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }}



