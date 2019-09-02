//
//  SignInViewController.swift
//  Freebee
//
//  Created by Anthony on 2/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase


class SignInViewController: UIViewController {
    
    @IBOutlet weak var continueWithFacebookButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var emailExists = false
    
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hides keyboard when view is tapped
        hideKeyboardWhenTapped()
        
        
        // applying gradient to the view
        view.backgroundColor = UIColor.clear
        let gradientView = GradientView(frame: self.view.bounds)
        view.insertSubview(gradientView, at: 0)
    }
    
    
    @IBAction func continueWithFacebook(_ sender: Any) {
        handleCustomFBLogin()
    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        print("Sign button clicked")
        signInWithEmail()
    }
    
    func signInWithEmail(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("Unable to sign in")
                return
            }
            print("Successfully signed in with email and password")
            self.goToHomePage()
        }
    }
    
    
    
    func handleCustomFBLogin(){
        
        let loginManager = LoginManager()
        
        // requesting permissions from facebook user
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, err) in
            if err != nil {
                print(err!)
                print("custom facebook login failed")
                return
            }
            // if user cancels login nothing will happen
            if result!.isCancelled{
                return
            }
            
            print("Successfully logged in to facebook")
            
            // setting variables for user to be saved to the database
            var email = "0"
            var name = "0"
        
            
            //getting details to save user
            GraphRequest(graphPath: "/me", parameters: ["fields" : "name, email"]).start { (connection, result, error) in
                if error != nil {
                    print("could not get user details", error ?? "")
                    return
                }
                print("The user details are ...")
                let dict = result as! NSDictionary
                email = dict["email"] as! String
                name = dict["name"] as! String
                
                // checking if email exists in database
                Firestore.firestore().collection("users").getDocuments(completion: { (snapshot, error) in
                    if error != nil {
                        print("user email could not be checked", error ?? "")
                        return
                    }
                    else {
                        for document in snapshot!.documents {
                            print(email)
                            if document.get("email") as! String == email {
                                print("email exists")
                                self.emailExists = true
                                break
                            } else {
                                self.emailExists = false
                            }
                        } // end of for
                        
                        if !self.emailExists {
                            
                            // saving user to firestore
                            self.saveFacebookUserToDatabase(name: name, age: "25", phoneNumber: "0270989872", address: "40 Palace Street", region: "Christchurch", email: email)
                            print("saved user to firestore with graph request")
                        }
                    }
                })
            }
            // takes user to home page after login
            self.goToHomePage()
        }
    } // end of func
    
    func saveFacebookUserToDatabase(name: String, age: String, phoneNumber: String, address: String, region: String, email: String){
        
        let userRef = Firestore.firestore().collection("users").document()
        userRef.setData([
            "name" : name,
            "age": age,
            "phoneNumber": phoneNumber,
            "address": address,
            "region": region,
            "email": email
            ])
    }
    
    func goToHomePage(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UINavigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    func setFBButtonTitle(){
        if AccessToken.isCurrentAccessTokenActive {
            continueWithFacebookButton.setTitle("Log out", for: .normal)
        } else {
            continueWithFacebookButton.setTitle("Continue with Facebook", for: .normal)
        }
    }
    
    func getUserDetails(){
        GraphRequest(graphPath: "/me", parameters: ["fields" : "name, email"]).start { (connection, result, error) in
            if error != nil {
                print("could not get user details", error ?? "")
                return
            }
            print("The user details are ...")
            let dict = result as! NSDictionary
            guard let email = dict["email"] else { return }
            guard let name = dict["name"] else { return }
            print("name is \(name) and email is \(email)")
        }
    }

    
}
