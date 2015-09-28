//
//  InputsFormViewController.swift
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2014-2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit
import XLForm
import Parse
import MapKit

class InputsFormViewController: XLFormViewController {
    var sum: Double = 350
    var delivery: Double = 100
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
//        self.navigationItem.rightBarButtonItem?.target = self
//        self.navigationItem.rightBarButtonItem?.action = "validateForm:"
    }
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
//    }
    
    
    
    //MARK: Actions
    
    func validateForm(buttonItem: UIBarButtonItem) {
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
    }
    
    
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
