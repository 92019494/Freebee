//
//  SettingsViewController.swift
//  Freebee
//
//  Created by Anthony on 3/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let layer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
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
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
