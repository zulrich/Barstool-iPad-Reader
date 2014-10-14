//
//  LoginViewController.swift
//  Barstool-iPad
//
//  Created by Zack Ulrich on 10/5/14.
//  Copyright (c) 2014 Zack Ulrich. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDataDelegate {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    
    var connection:NSURLConnection!
    var rData:NSMutableData!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.usernameTextField.becomeFirstResponder()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == self.passwordTextField)
        {
            self.sendLogin()
            return true
        }
        return false
    }
    
    func sendLogin()
    {
        
        if(self.passwordTextField.text.length() > 0 && self.usernameTextField.text.length() > 0)
        {
            var loginStr = "userid=12f3c396a447636e175c04b74d6fed52&app_type=barstool_ios&call=new-login&version=1.13&json={\"username\":\"\(self.usernameTextField.text)\",\"password\":\"\(self.passwordTextField.text)\"}&hash=a3dccf3678438a2fd6f9b9446baa8ed3"
            
            var loginRequest = NSMutableURLRequest(URL: NSURL(string:"http://www.barstoolsports.com/wp-content/plugins/json-generate/get.php"));
            
            loginRequest.HTTPBody = loginStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true);
            loginRequest.HTTPMethod = "POST";
            
            self.rData = NSMutableData()
            self.connection = NSURLConnection(request: loginRequest, delegate: self);
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.rData.appendData(data)
    }
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if(self.rData.length > 0)
        {
            self.handleResponse()
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        println("login response \(response)")
    }
    
    func handleResponse()
    {
        var error:NSError?
        
        var responseArr: NSMutableArray? = NSJSONSerialization.JSONObjectWithData(self.rData, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSMutableArray;
        
        if(error == nil)
        {
           println("error \(error)")
        }
        
        if(responseArr?.count == 1)
        {
            var str = responseArr?.objectAtIndex(0).objectAtIndex(1).objectForKey("message") as NSString
            
            var av:UIAlertView = UIAlertView(title: "Login Failed", message: str, delegate: nil, cancelButtonTitle: "Cancel")
            
            av.show()
            
        }
        
        else if(responseArr?.count == 2)
        {
            var dict = responseArr?.objectAtIndex(1).objectAtIndex(0) as NSDictionary
            
            var currentUser:User = User(dict: dict)
            
            NSUserDefaults.standardUserDefaults().setObject(dict, forKey: "currentUser")
            
            
            self.dismissViewControllerAnimated(true , completion: {})
        }
    }

    @IBAction func loginPressed(sender: AnyObject) {
        
        self.sendLogin()
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: {})
    }


}
