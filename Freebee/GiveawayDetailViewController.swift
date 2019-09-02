//
//  GiveawayDetailViewController.swift
//  Freebee
//
//  Created by Anthony on 6/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import Firebase

class GiveawayDetailViewController: UIViewController {
    let viewLayer = CAGradientLayer()
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
    
    var user = User(name: "", phoneNumber: "", address: "l", region: "k", age: "k", email: "k")


    var giveaway = Giveaway(giveawayID: "a", active: false, winner: "", name: "a", cost: "a", image: "a", dateClosing: Timestamp(), details: "a", category: "a", shareEntries: [""], adEntries: [""], location: "a", code: "", advertiserID: "a", advertiserName: "a")
    
  
    let adButtonLayer = CAGradientLayer()
    let adShapeLayer = CAShapeLayer()
    let shareButtonLayer = CAGradientLayer()
    let shareShapeLayer = CAShapeLayer()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up labels and image
        businessLabel.text = giveaway?.advertiserName
        myImageView.image = UIImage(named: giveaway?.image ?? "")
        giveawayLabel.text = giveaway?.name
   
        
        // counting down closing date label
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            self.dateClosing.text = self.giveaway?.dateClosing.dateValue().getTime()
        }
        
        costLabel.text = giveaway?.cost
        locationLabel.text = giveaway?.location
        prizeDetailLabel.text = giveaway?.details
        
        // setting up share button
        shareButton.backgroundColor = UIColor.clear
        shareButton.layer.cornerRadius = shareButton.bounds.height / 2
        shareButton.setTitleColor(UIColor.darkGray, for: .normal)

        if (giveaway?.shareEntries.contains(user!.email))!{
            shareButton.layer.borderColor = UIColor.clear.cgColor
            shareButton.setTitle("Completed", for: .normal)
            shareButton.applyButtonGradient()
            shareButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            
            shareButton.setTitle("Share To Enter", for: .normal)
            shareButton.applyBorder(layer: shareButtonLayer, shape: shareShapeLayer)
            
        }
        
        // setting up ad button
        adButton.backgroundColor = UIColor.clear
        adButton.layer.cornerRadius = adButton.bounds.height / 2
        adButton.setTitleColor(UIColor.darkGray, for: .normal)
 
        
    
        if ((giveaway?.adEntries.contains(user!.email))!){
            adButton.layer.borderColor = UIColor.clear.cgColor
            adButton.setTitle("Completed", for: .normal)
            adButton.applyButtonGradient()
            adButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            
            adButton.setTitle("Watch Ad To Enter", for: .normal)
            adButton.applyBorder(layer: adButtonLayer, shape: adShapeLayer)
            
        }
        
        

        myScrollView.layer.cornerRadius = 15
        view.backgroundColor = UIColor.clear
        
        let gradientView = GradientView(frame: self.view.bounds)
        view.insertSubview(gradientView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        // resizing button borders
        adButtonLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 50)
        adShapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 50), cornerRadius: 25).cgPath
        shareButtonLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 50)
        shareShapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 50), cornerRadius: 25).cgPath
    }

    
    @IBAction func shareButtonClicked(_ sender: Any) {
        print("Share Button Clicked")
        if (giveaway?.shareEntries.contains(user!.email))!{
            print("already shared")
        } else {
            db.collection("giveaways").document(giveaway!.giveawayID).setData([
                "shareEntries": [ user!.email ]
                ], merge: true)
        }
    }
    
    @IBAction func adButtonClicked(_ sender: Any) {
        print("Ad Button Clicked")
        if (giveaway?.adEntries.contains(user!.email))!{
            print("already watched")
        } else {
            db.collection("giveaways").document(giveaway!.giveawayID).setData([
                "adEntries": [ user!.email ]
                ], merge: true)
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
extension Date {
    
    func getTime() -> String{
        
        let futureDate = self
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated // May delete the word brief to let Xcode show you the other options
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.maximumUnitCount = 2   // Show just one unit (i.e. 1d vs. 1d 6hrs)
        
        // force unwrapped
        let formattedString = formatter.string(from: now, to: futureDate)!
        if formattedString.contains("-"){
            return "Winner is being drawn"
        } else {
        return formatter.string(from: now, to: futureDate)!
        }
    }
}
