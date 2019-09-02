
//
//  RegisterViewController.swift
//  Freebee
//
//  Created by Anthony on 27/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    let viewLayer = CAGradientLayer()


    let db = Firestore.firestore()
    var fieldsCompleted = false
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var nameHelpLabel: UILabel!
    @IBOutlet weak var ageHelpLabel: UILabel!
    @IBOutlet weak var phoneHelpLabel: UILabel!
    @IBOutlet weak var addressHelpLabel: UILabel!
    @IBOutlet weak var regionHelpLabel: UILabel!
    @IBOutlet weak var emailHelpLabel: UILabel!
    @IBOutlet weak var passwordHelpLabel: UILabel!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearHelpText()
        
        
        hideKeyboardWhenTapped()
        registerButton.layer.cornerRadius = registerButton.bounds.height / 2
        //registerButton.layer.borderColor = UIColor(red: 10/255, green: 110/255, blue: 110/255, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
        registerButton.applyButtonGradient()
        
        let gradientView = GradientView(frame: self.view.bounds)
        view.insertSubview(gradientView, at: 0)
    }
    

    override func viewDidLayoutSubviews() {
        
        

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func clearHelpText(){
        nameHelpLabel.text = ""
        ageHelpLabel.text = ""
        phoneHelpLabel.text = ""
        addressHelpLabel.text = ""
        regionHelpLabel.text = ""
        emailHelpLabel.text = ""
        passwordHelpLabel.text = ""
    }
    
    
    
    @IBAction func register(_ sender: Any) {
        registerUser()
    }
    
    func registerUser(){
        var name = ""
        var age = ""
        var phoneNumber = ""
        var address = ""
        var region = ""
        var email = ""
        var password = ""
        
        fieldsCompleted = true
        
        if nameTextField.text != "" {  name = nameTextField.text! }
        else {
            nameHelpLabel.text = "Name field must not be empty"
            fieldsCompleted = false
        }
        if ageTextField.text != "" {  age = ageTextField.text! }
        else {
            ageHelpLabel.text = "Age field must not be empty"
            fieldsCompleted = false
        }
        if phoneNumberTextField.text != "" {  phoneNumber = phoneNumberTextField.text! }
        else{
            phoneHelpLabel.text = "Phone number field must not be empty"
            fieldsCompleted = false
        }
        if addressTextField.text != "" {  address = addressTextField.text! }
        else {
            addressHelpLabel.text = "Address field must not be empty"
            fieldsCompleted = false
        }
        if regionTextField.text != "" {  region = regionTextField.text! }
        else {
            regionHelpLabel.text = "Region field must not be empty"
            fieldsCompleted = false
        }
        if emailTextField.text != "" {  email = emailTextField.text! }
        else {
            emailHelpLabel.text = "Email field must not be empty"
            fieldsCompleted = false
        }
        if passwordTextField.text != "" {  password = passwordTextField.text! }
        else {
            passwordHelpLabel.text = "Password field must not be empty"
            fieldsCompleted = false
        }
        
        if fieldsCompleted {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    print("Creating user unsuccessful")
                    print( error ?? "")
                    self.emailHelpLabel.text = "This email is already in use. Please enter a new one"
                    return
                }
                self.saveUserToDatabase(name: name, age: age, phoneNumber: phoneNumber, address: address, region: region, email: email)
                print("user saved to database")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UINavigationController
                self.present(vc, animated: true, completion: nil)
            }
        }
        
    }
    
    
    func saveUserToDatabase(name: String, age: String, phoneNumber: String, address: String, region: String, email: String){
        let userRef = db.collection("users").document()
        userRef.setData([
            "name" : name,
            "age": age,
            "phoneNumber": phoneNumber,
            "address": address,
            "region": region,
            "email": email
            ])
    }
    
}










// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
