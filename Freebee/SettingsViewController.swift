//
//  SettingsViewController.swift
//  Freebee
//
//  Created by Anthony on 3/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let viewLayer = CAGradientLayer()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var nameHelpText: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var ageHelpText: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneHelpText: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressHelpText: UILabel!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var regionHelpText: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailHelpText: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordHelpText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = UIColor.clear
    
        updateButton.layer.cornerRadius = updateButton.bounds.height / 2
        updateButton.applyButtonGradient()
        
        let gradientView = GradientView(frame: self.view.bounds)
        view.insertSubview(gradientView, at: 0)
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func hideHelpText(){
        nameHelpText.isHidden = true
        ageHelpText.isHidden = true
        phoneHelpText.isHidden = true
        addressHelpText.isHidden = true
        regionHelpText.isHidden = true
        emailHelpText.isHidden = true
        passwordHelpText.isHidden = true
    }
    
    
}
