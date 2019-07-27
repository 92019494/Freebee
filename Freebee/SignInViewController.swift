//
//  SignInViewController.swift
//  Freebee
//
//  Created by Anthony on 2/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase


class SignInViewController: UIViewController {

    @IBOutlet weak var continueWithFacebookButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    let loginManager = LoginManager()
    let layer = CAGradientLayer()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFBButtonTitle()
        
        view.backgroundColor = UIColor.clear

        layer.frame = view.bounds
        layer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        layer.locations = [0.05,1]
        layer.startPoint = CGPoint(x:0.5,y:0)
        layer.endPoint = CGPoint(x:0.5, y:1)
        view.layer.insertSublayer(layer, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        layer.frame = view.bounds
    }
    
    
    @IBAction func continueWithFacebook(_ sender: Any) {
            handleCustomFBLogin()
        
    }
    

    @IBAction func signInButton(_ sender: Any) {
        print("Sign button clicked")
        getEmail()
       
    }
    
    func getEmail(){
        GraphRequest(graphPath: "/me", parameters: ["fields": "email"]).start { (connection, result, err) in
            if err != nil {
                print(err ?? "")
            }
            if let dict = result as? NSDictionary {
                let email = dict["email"] as? String
                print(email ?? "")
            }
        }
    }
    
    func showUserDetails() {
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
                print(err!)
                return
            }
            print(result ?? "no details")
        
        }
    }
    
    
    func handleCustomFBLogin(){
        let loginManager = LoginManager()
        
        if AccessToken.isCurrentAccessTokenActive {
            loginManager.logOut()
            self.continueWithFacebookButton.setTitle("Continue with Facebook", for: .normal)
        }
        else {
            loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, err) in
                if err != nil {
                    print(err!)
                    print("custom facebook login failed")
                    return
                }
                if result!.isCancelled{
                    return
                }
                print("Successfully logged in to facebook")
                self.continueWithFacebookButton.setTitle("Log out", for: .normal)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UINavigationController
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    } // end of func
    
    func setFBButtonTitle(){
        if AccessToken.isCurrentAccessTokenActive {
            continueWithFacebookButton.setTitle("Log out", for: .normal)
        } else {
            continueWithFacebookButton.setTitle("Continue with Facebook", for: .normal)
        }
    }
 

}
