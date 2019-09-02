//
//  TermsViewController.swift
//  Freebee
//
//  Created by Anthony on 2/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import Foundation

class TermsViewController: UIViewController {
    
    
    @IBOutlet weak var myScrollView: UIScrollView!
    let viewLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myScrollView.layer.cornerRadius = 15
        view.backgroundColor = UIColor.clear
        
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

}
