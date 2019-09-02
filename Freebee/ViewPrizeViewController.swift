//
//  ViewPrizeViewController.swift
//  Freebee
//
//  Created by Anthony on 29/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import  Firebase

class ViewPrizeViewController: UIViewController {

    let userdID = "1"
    let viewLayer = CAGradientLayer()
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var giveawayLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    var giveaway = Giveaway(giveawayID: "a", active: false, winner: "", name: "a", cost: "a", image: "a", dateClosing: Timestamp(), details: "a", category: "a", shareEntries: [""], adEntries: [""], location: "a", code: "", advertiserID: "a", advertiserName: "a")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = GradientView(frame: self.view.bounds)
        view.insertSubview(gradientView, at: 0)
        
        contentView.layer.cornerRadius = 10
        myImageView.layer.cornerRadius = 10
        
        myImageView.image = UIImage(named: giveaway!.image)
        businessLabel.text = giveaway?.advertiserName
        giveawayLabel.text = giveaway?.name
        if giveaway?.winner == userdID {
            winnerLabel.text = "You"
            wonLabel.text = "Congratulations your a winner"
        } else {
            winnerLabel.text = giveaway?.winner
            wonLabel.text = "Sorry you weren't a winner this time"
        }
        
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
