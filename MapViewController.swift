//
//  MapViewController.swift
//  ExpressFood
//
//  Created by Denis Karpenko on 11.05.15.
//  Copyright (c) 2015 Denis Karpenko. All rights reserved.
//

import UIKit
import MapKit
import Parse
class MapViewController: UIViewController, UISearchBarDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate {
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    @IBOutlet weak var NameField: UITextField!
    var adrees = ""

    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var NumberField: UITextField!
    @IBOutlet weak var flatField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        //self.performSegueWithIdentifier("Logged", sender: nil)//need to delete!
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Введите свой адрес"
        // Present the view controller
        presentViewController(searchController, animated: true, completion: nil)
        //UITEXTFIELD ADJUSTING
        var numLeft = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        numLeft.text = "+7"
        numLeft.textColor = UIColor.grayColor()
        numLeft.font = UIFont(name: "Avenir Next Regular", size: 14)
        self.NumberField.leftView = numLeft
        self.NumberField.leftViewMode = UITextFieldViewMode.Always
        self.emailField.leftViewMode = UITextFieldViewMode.Always
        self.flatField.leftViewMode = UITextFieldViewMode.Always
        self.NameField.leftViewMode = UITextFieldViewMode.Always
        self.PasswordField.leftViewMode = UITextFieldViewMode.Always
        
        var emailView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        emailView.image = UIImage(named: "email")
        var secondview = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        secondview.addSubview(emailView)
        emailField.leftView = secondview
        
        var lockView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        lockView.image = UIImage(named: "locked")
        var SecndLock = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        SecndLock.addSubview(lockView)
        PasswordField.leftView = SecndLock
        var NameView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        NameView.image = UIImage(named: "user")
        var SecndName = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        SecndName.addSubview(NameView)
        NameField.leftView = SecndName

        var FlatView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        FlatView.image = UIImage(named: "house")
        var SecndFlat = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        SecndFlat.addSubview(FlatView)
        flatField.leftView = SecndFlat
        // Do any additional setup after loading the view.
    }
    @IBAction func Enter(sender: AnyObject) {
        //method which register user in base and return ID
        
        self.SignUp()
        
        
        //Enter pushed
        
    }
    
    func handleTap(sender : UIView) { //tap
        self.view.endEditing(true);
        //println("Tap Gesture recognized")
    }
    
    
    func SignUp(){ //registration PArse.COM and saving Defaults !
        let defaults = NSUserDefaults.standardUserDefaults()
        var user = PFUser()
        user.username = self.emailField.text
        user.password = self.PasswordField.text
        user.email = self.emailField.text
        // other fields can be set just like with PFObject
        user["phone"] = "+7\(self.NumberField.text)"
        user["FirstName"] = self.NameField.text
        user["AdressField"] = self.adrees
        user["flat"] = self.flatField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                var alert = UIAlertView(title: nil, message: "Упс:( \(errorString!)", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
                // Show the errorString somewhere and let the user try again.
            } else {
                defaults.setObject("\(self.emailField.text)", forKey: "Name")
                defaults.setObject("\(self.PasswordField.text)", forKey: "Password")
                self.performSegueWithIdentifier("Logged", sender: nil)
                // Hooray! Let them use the app now.
            }
        }
        
        
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    @IBAction func PushSearch(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.placeholder = "Введите свой адрес"
        // Present the view controller
        presentViewController(searchController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            let fullNameArr = searchBar.text.componentsSeparatedByString(" ")
            if(fullNameArr.count > 2) {
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                self.presentViewController(self.searchController, animated: true, completion: nil)
                return
            }
            //3

            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
            
            let dormitoryCordinates = CLLocation(latitude: 55.6672199781833, longitude: 37.2828599531204)// center of our delivery
            let regionRadius: CLLocationDistance = 200
            var mypoint = self.pointAnnotation.coordinate
            var Home = CLLocation(latitude: mypoint.latitude, longitude: mypoint.longitude)
            //self.centerMapOnLocation(self.pointAnnotation.coordinate)
            self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate,
                regionRadius * 2.0, regionRadius * 2.0), animated: true)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            //self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation)
            if(dormitoryCordinates.distanceFromLocation(Home)>2000){
                var alert = UIAlertView(title: nil, message: "К сожалению мы еще не работаем здесь ;(;(", delegate: self, cancelButtonTitle: "Ок")
                alert.show()
            }
            else{
                var alert = UIAlertView(title: nil, message: "Вам повезло, мы работаем у вас в районе !:)", delegate: self, cancelButtonTitle: "Продолжить регистрацию")
                alert.show()
                self.adrees = searchBar.text
                self.NameField.hidden = false
                self.emailField.hidden = false
                self.flatField.hidden = false
                self.NumberField.hidden = false
                self.EnterButton.hidden = false
                self.PasswordField.hidden = false
                

                
            }
            }
            else{
                var alert = UIAlertView(title: nil, message: "Введите полный адрес !;)", delegate: self, cancelButtonTitle: "Продолжить регистрацию")
                alert.show()
                
            }
        }
        
            }
    
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
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
