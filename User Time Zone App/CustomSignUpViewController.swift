//
//  CustomSignUpViewController.swift
//  User Time Zone App
//
//  Created by Tyler Bunting on 8/13/15.
//  Copyright (c) 2015 Tyler Bunting. All rights reserved.
//

import UIKit
import Parse

class CustomSignUpViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Functions
    
    func localTimeZone() -> String {
        return NSTimeZone.localTimeZone().name
    }
    
    
    //MARK: Actions
    
    @IBAction func signupAction(sender: AnyObject) {
        
        var firstName = self.firstNameField.text
        var lastName = self.lastNameField.text
        var username = self.usernameField.text
        var email = self.emailField.text
        var password = self.passwordField.text
        var passwordConfirm = self.confirmPasswordField.text
        
        if (count(username.utf16) < 4 || count(password.utf16) < 5) {
            
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 4 and Password must be greater than 5", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }else if (count(email.utf16) < 8) {
            var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email", delegate: self, cancelButtonTitle: "OK")
        
            alert.show()

            
        }else if (password != passwordConfirm) {
            
            var alert = UIAlertView(title: "Invalid", message: "Password and Password Confirmation do not match", delegate: self, cancelButtonTitle: "OK")
            
            alert.show()
            
        }else if ((count(firstName.utf16)) < 2 || (count(lastName.utf16)) < 2) {
            
            var alert = UIAlertView(title: "Invalid", message: "Must Enter Both First and Last Name", delegate: self, cancelButtonTitle: "OK")
        
            alert.show()
        
        }else {
            
            self.actInd.startAnimating()
            
            var newUser = PFUser()
            
            
            newUser.username = username
            newUser.password = password
            newUser.email = email
            newUser["firstName"] = firstName
            newUser["lastName"] = lastName
            newUser["timeZone"] = localTimeZone()
            
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((error) != nil) {
                    
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                }else {
                                        
                    var alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()

                }
            })
        }
    }
    
    @IBAction func resignKeyboard(sender: AnyObject) {
        sender.resignFirstResponder()
    }
}