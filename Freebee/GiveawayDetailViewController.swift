//
//  GiveawayDetailViewController.swift
//  Freebee
//
//  Created by Anthony on 6/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit

class GiveawayDetailViewController: UIViewController {
    let layer = CAGradientLayer()
    let userID = "1"
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var giveawayLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var prizeDetailLabel: UILabel!
    @IBOutlet weak var dateClosing: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var adButton: UIButton!
    
    var giveaway = Giveaway(giveawayID: "a", name: "a", cost: "a", image: "a", dateClosing: "a", details: "a", category: "a", shareEntries: [""], adEntries: [""], location: "a", advertiserID: "a", advertiserName: "a")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up labels and image
        businessLabel.text = giveaway?.advertiserName
        myImageView.image = UIImage(named: giveaway?.image ?? "")
        giveawayLabel.text = giveaway?.name
        dateClosing.text = giveaway?.dateClosing
        costLabel.text = giveaway?.cost
        locationLabel.text = giveaway?.location
        prizeDetailLabel.text = giveaway?.details
        
        // setting up share button
        shareButton.backgroundColor = UIColor.clear
        shareButton.layer.cornerRadius = 20
        shareButton.setTitleColor(UIColor.gray, for: .normal)
        shareButton.layer.borderWidth = 3
        shareButton.layer.borderColor = UIColor.blue.cgColor
        if (giveaway?.shareEntries.contains(userID))!{
            shareButton.layer.borderColor = UIColor.clear.cgColor
            shareButton.setTitle("Completed", for: .normal)
            shareButton.applyGradient(colours: [UIColor.blue, UIColor.purple])
            shareButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        // setting up ad button
        adButton.backgroundColor = UIColor.clear
        adButton.layer.cornerRadius = 20
        adButton.setTitleColor(UIColor.gray, for: .normal)
        adButton.layer.borderWidth = 3
        adButton.layer.borderColor = UIColor.blue.cgColor
        
    
        if (giveaway?.adEntries.contains(userID))!{
            adButton.layer.borderColor = UIColor.clear.cgColor
            adButton.setTitle("Completed", for: .normal)
            adButton.applyGradient(colours: [UIColor.blue, UIColor.purple])
            adButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        //setting up navigation controller
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        myScrollView.layer.cornerRadius = 15
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

    @IBAction func shareButtonClicked(_ sender: Any) {
        print("Share Button Clicked")
    }
    @IBAction func adButtonClicked(_ sender: Any) {
        print("Ad Button Clicked")
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
