//
//  FirstScreenViewController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 11.05.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import Parse
class FirstScreenViewController: UIViewController,UITextFieldDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        // вывод алерта при отсутсвии интернета
        //let mycart = Cart.sharedCart()
        //if(mycart.internet == false){
        //var alert = UIAlertView(title: "Нет интернета", message: "К сожалению для работы приложения требуется интернет(", delegate: nil, cancelButtonTitle: "OK")
        //alert.show()
        //}

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var EnterPush: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func Enter(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(NameField.text, password:PasswordField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let mycart = Cart.sharedCart()
                mycart.user = user
                defaults.setObject("\(self.NameField.text)", forKey: "Name")
                defaults.setObject("\(self.PasswordField.text)", forKey: "Password")

                self.performSegueWithIdentifier("First", sender: nil)
                // Do stuff after successful login.
            } else {
                let errorString = error!.userInfo?["error"] as? NSString
                var alert = UIAlertView(title: nil, message: "Упс:( \(errorString!)", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                // The login failed. Check error to see why.
            }
        }
        
    }
    
    func handleTap(sender : UIView) { //tap
        self.view.endEditing(true);
        //println("Tap Gesture recognized")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
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
