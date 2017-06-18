//
//  ViewController.swift
//  feeder
//
//  Created by Karan Balakrishnan on 5/20/17.
//  Copyright © 2017 Karan Balakrishnan. All rights reserved.
//

import UIKit
import LFLoginController
import ILLoginKit
import Fabric
import TwitterKit

class LoginViewController: UIViewController {
    
    var loginComplete : Bool = false
    var username : String?
    lazy var loginCoordinator: LoginCoordinator = {
        return LoginCoordinator(rootViewController:self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.loginComplete{
            loginCoordinator.tt = self;
            loginCoordinator.start()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aa(username : String) {
        self.username = username
        self.dismiss(animated: false, completion: {
        
           self.performSegue(withIdentifier: "showMainDisplay", sender: self)
        
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMainDisplay"{
            if let destNavController = segue.destination as? UINavigationController{
                if let destVC = destNavController.topViewController as? MainDisplayViewController{
                    destVC.username = self.username!
                }
            }
        }
    }
}

class LoginCoordinator: ILLoginKit.LoginCoordinator {
    
    // MARK: - LoginCoordinator
    public var tt : LoginViewController = LoginViewController()
    override func start() {
        super.start()
        configureAppearance()
    }
    
    override func finish() {
        super.finish()

    }
    
    // MARK: - Setup
    
    func configureAppearance() {
        // Customize LoginKit. All properties have defaults, only set the ones you want.
        
        // Customize the look with background & logo images
        backgroundImage = #imageLiteral(resourceName: "bkg")
        // mainLogoImage =
        // secondaryLogoImage =
        
        // Change colors
        tintColor = UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1)
        errorTintColor = UIColor(red: 253.0/255.0, green: 227.0/255.0, blue: 167.0/255.0, alpha: 1)
        
        // Change placeholder & button texts, useful for different marketing style or language.
        loginButtonText = "Sign In"
        signupButtonText = "Create Account"
        facebookButtonText = "Login with Facebook"
        forgotPasswordButtonText = "Forgot password?"
        recoverPasswordButtonText = "Recover"
        namePlaceholder = "Name"
        emailPlaceholder = "E-Mail"
        passwordPlaceholder = "Password!"
        repeatPasswordPlaceholder = "Confirm password!"
        
        
        let logInButton = TWTRLogInButton { (session, error) in
            if let unwrappedSession = session {
                let alert = UIAlertController(title: "Logged In",
                                              message: "User \(unwrappedSession.userName) has logged in",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.rootViewController!.present(alert, animated: true, completion: nil)
            } else {
                NSLog("Login error: %@", error!.localizedDescription);
            }
        }
        
        // TODO: Change where the log in button is positioned in your view
            logInButton.center = self.rootViewController!.view!.center
            self.rootViewController!.view!.addSubview(logInButton)

    }
    
    // MARK: - Completion Callbacks
    
    override func login(email: String, password: String) {

        self.tt.loginComplete = true
        self.tt.aa(username: email)
//        })
        
    
    }
    
    override func signup(name: String, email: String, password: String) {
        // Handle signup via your API
        print("Signup with: name = \(name) email =\(email) password = \(password)")
    }
    
    override func enterWithFacebook(profile: FacebookProfile) {
        // Handle Facebook login/signup via your API
        print("Login/Signup via Facebook with: FB profile =\(profile)")
        
    }
    
    override func recoverPassword(email: String) {
        // Handle password recovery via your API
        print("Recover password with: email =\(email)")
    }
    
}

