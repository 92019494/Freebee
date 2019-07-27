
//
//  RegisterViewController.swift
//  Freebee
//
//  Created by Anthony on 27/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    

    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.applyGradient(colours:[UIColor.blue, UIColor.purple])
        hideKeyboardWhenTapped()
        registerButton.layer.borderWidth = 3
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderColor = UIColor(red: 10/255, green: 110/255, blue: 110/255, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
