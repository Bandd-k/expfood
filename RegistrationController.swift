//
//  RegistrationController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 03.08.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import XLForm
import Parse
import MapKit
class RegistrationController: XLFormViewController {
    var radius: CLLocationDistance = 3000
    var xcord = 55.6672199781833
    var ycord = 37.2828599531204
    private enum Tags : String {
        case ValidationName = "Name"
        case ValidationEmail = "Email"
        case ValidationPassword = "Password"
        case ValidationPhone = "Phone"
        case ValidationStreet = "Street"
        case ValidationHouse = "House"
        case ValidationFlat = "Flat"
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    func initializeForm() {
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Регистрация")
        
        section = XLFormSectionDescriptor()
        section.title = "Личные данные"
        section.footerTitle = "Нашему курьеру может понадобиться позвонить вам в случае отсутвия товаров или по другим требующим вашего решения причинам"
        form.addFormSection(section)
        // Name
        //        row = XLFormRowDescriptor(tag: Tags.HideRow.rawValue, rowType: XLFormRowDescriptorTypeBooleanCheck, title: "Я первый раз заказываю")
        //        row.value = 0
        //        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.ValidationName.rawValue, rowType: XLFormRowDescriptorTypeText, title:"Имя")
        row.cellConfigAtConfigure["textField.placeholder"] = "Денис Карпенко"
        row.cellConfigAtConfigure["textField.textAlignment"] =  NSTextAlignment.Right.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Email Row
        row = XLFormRowDescriptor(tag: Tags.ValidationEmail.rawValue, rowType: XLFormRowDescriptorTypeText, title:"Email")
        row.cellConfigAtConfigure["textField.placeholder"] = "deniska@expfood.ru"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        row.addValidator(XLFormValidator.emailValidator())
        section.addFormRow(row)
        
        //password
        row = XLFormRowDescriptor(tag: Tags.ValidationPassword.rawValue, rowType: XLFormRowDescriptorTypePassword, title:"Пароль")
        row.cellConfigAtConfigure["textField.placeholder"] = "12345"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        //row.hidden = "$\(Tags.HideRow.rawValue)==0"
        row.required = true
        section.addFormRow(row)
        //Phone
        row = XLFormRowDescriptor(tag: Tags.ValidationPhone.rawValue, rowType: XLFormRowDescriptorTypePhone, title:"Телефон")
        row.cellConfigAtConfigure["textField.placeholder"] = "89851480903"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        //row.hidden = "$\(Tags.HideRow.rawValue)==0"
        row.addValidator(XLFormRegexValidator(msg: "not number", andRegexString: "[8][0-9]{10}"))
        section.addFormRow(row)
        
        
        // start Address section
        section = XLFormSectionDescriptor()
        section.title = "Address"
        form.addFormSection(section)
        // Street
        row = XLFormRowDescriptor(tag: "Street", rowType: XLFormRowDescriptorTypeText, title:"Улица")
        row.cellConfigAtConfigure["textField.placeholder"] = "Арбат"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        section.addFormRow(row)
        // home
        row = XLFormRowDescriptor(tag: "House", rowType: XLFormRowDescriptorTypeText, title:"Дом")
        row.cellConfigAtConfigure["textField.placeholder"] = "25"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        section.addFormRow(row)
        
        // Flat
        row = XLFormRowDescriptor(tag: "Flat", rowType: XLFormRowDescriptorTypeDecimal, title:"Квартира")
        row.cellConfigAtConfigure["textField.placeholder"] = "37"
        row.cellConfigAtConfigure["textField.textAlignment"] = NSTextAlignment.Right.rawValue
        row.required = true
        section.addFormRow(row)
        
        // button
        section = XLFormSectionDescriptor()
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: "reg", rowType: XLFormRowDescriptorTypeButton, title: "Начать покупки")
        row.cellConfig["textLabel.textColor"] = UIColor.appColor()
        row.action.formSelector = "reg:"
        section.addFormRow(row)
        self.form = form
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //get zone of delivery
        var query = PFQuery(className:"Radius")
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
                println(error)
            }
        }
    }
    
    func reg(sender: XLFormRowDescriptor)->(){
        if validate(){
        var str = self.form.formRowWithTag("Street")!.value as? String!
        var str1 = self.form.formRowWithTag("House")!.value as? String!
        var final = "Одинцово " + str! + " " + str1! // вначале валидейт!
        checkAddress(final)
        }
        self.deselectFormRow(sender)
    }
    func SignUp(){ //registration PArse.COM and saving Defaults !
        let defaults = NSUserDefaults.standardUserDefaults()
        var user = PFUser()
        user.username = self.form.formRowWithTag("Email")!.value as? String
        user.password = self.form.formRowWithTag("Password")!.value as? String
        user.email = self.form.formRowWithTag("Email")!.value as? String
        // other fields can be set just like with PFObject
        user["phone"] = self.form.formRowWithTag("Phone")!.value as? String
        user["FirstName"] = self.form.formRowWithTag("Name")!.value as? String
        user["Street"] = self.form.formRowWithTag("Street")!.value as? String
        user["house"] = self.form.formRowWithTag("House")!.value as? String
        user["flat"] = (self.form.formRowWithTag("Flat")!.value as? Int)?.description
        user["free"] = true;
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                var alert = UIAlertView(title: nil, message: "Упс:( \(errorString!)", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                // Show the errorString somewhere and let the user try again.
            } else {
               // defaults.setObject("\(user.username)", forKey: "Name")
               // defaults.setObject("\(user.password)", forKey: "Password")
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
                println(localSearchResponse.boundingRegion.center.latitude)
                println(localSearchResponse.boundingRegion.center.longitude)
                let Home = CLLocation(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)
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
                    self.SignUp()
                }
            }
        }
        return bl
    }
    func validate()->Bool{
        var bl:Bool = true
        let array = self.formValidationErrors()
        for errorItem in array {
            bl = false
            let error = errorItem as! NSError
            let validationStatus : XLFormValidationStatus = error.userInfo![XLValidationStatusErrorKey] as! XLFormValidationStatus
            if validationStatus.rowDescriptor!.tag == Tags.ValidationName.rawValue {
//                if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)!) {
//                    cell.backgroundColor = UIColor.orangeColor()
//                    UIView.animateWithDuration(0.3, animations: { () -> Void in
//                        cell.backgroundColor = UIColor.whiteColor()
//                    })
//                }
            }
            else if validationStatus.rowDescriptor!.tag == Tags.ValidationEmail.rawValue ||
                validationStatus.rowDescriptor!.tag == Tags.ValidationPassword.rawValue ||
                validationStatus.rowDescriptor!.tag == Tags.ValidationPhone.rawValue ||
                validationStatus.rowDescriptor!.tag == Tags.ValidationStreet.rawValue ||
                validationStatus.rowDescriptor!.tag == Tags.ValidationHouse.rawValue ||
                validationStatus.rowDescriptor!.tag == Tags.ValidationFlat.rawValue
            {
//                    if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)!) {
//                        self.animateCell(cell)
//                    }
                if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)!) {
                    cell.backgroundColor = UIColor.orangeColor()
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.backgroundColor = UIColor.whiteColor()
                    })
                }
            }
        }
        return bl

    }
    
    
    
    //MARK: Actions
    
//    func validateForm(buttonItem: UIBarButtonItem) {
//        let array = self.formValidationErrors()
//        for errorItem in array {
//            let error = errorItem as! NSError
//            let validationStatus : XLFormValidationStatus = error.userInfo![XLValidationStatusErrorKey] as! XLFormValidationStatus
//            if validationStatus.rowDescriptor!.tag == Tags.ValidationName.rawValue {
//                if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)!) {
//                    cell.backgroundColor = UIColor.orangeColor()
//                    UIView.animateWithDuration(0.3, animations: { () -> Void in
//                        cell.backgroundColor = UIColor.whiteColor()
//                    })
//                }
//            }
//            else if validationStatus.rowDescriptor!.tag == Tags.ValidationEmail.rawValue ||
//                validationStatus.rowDescriptor!.tag == Tags.ValidationPassword.rawValue ||
//                validationStatus.rowDescriptor!.tag == Tags.ValidationPhone.rawValue {
//                    if let cell = self.tableView.cellForRowAtIndexPath(self.form.indexPathOfFormRow(validationStatus.rowDescriptor)!) {
//                        self.animateCell(cell)
//                    }
//            }
//        }
//    }
    
    
    //MARK: - Helperph
    
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
