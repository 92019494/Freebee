//
//  FreebeeViewController.swift
//  Freebee
//
//  Created by Anthony on 2/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FreebeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference?
    let db = Firestore.firestore()
    var giveawaysActive = [Giveaway]()
    var giveawaysLost = [Giveaway]()
    var giveawaysWon = [Giveaway]()
    
    let viewLayer = CAGradientLayer()
    var loadingView = UIView()
    var loadingLabel = UILabel()
    var loadingIcon = UIActivityIndicatorView(style: .gray)
    var cellHeight = 144
    
    //temporary user id for testing
    let userID = "1"
    
    @IBOutlet weak var lostLabel: UILabel!
    @IBOutlet weak var lostLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var wonLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var winnerTableView: UITableView!
    @IBOutlet weak var winnerTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTableView: UITableView!
    @IBOutlet weak var bottomTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var topTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // firestore ref
        ref = Database.database().reference()
        
        
        // loading giveaways
        fetchGiveaways()
        
        
        // hiding view while rest of content loads
        myContentView.isHidden = true
        
        
        // adding loading view
        setUpLoadingView()
        
        
        // setting background gradient colour
        myContentView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
        let gradientView = GradientView(frame: self.view.bounds)
        view.insertSubview(gradientView, at: 0)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topTableView {
            return (giveawaysActive.count)
        } else if tableView == bottomTableView {
            return (giveawaysLost.count)
        } else if tableView == winnerTableView {
            return (giveawaysWon.count)
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == winnerTableView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewPrizeViewController") as! ViewPrizeViewController
            
            vc.giveaway = self.giveawaysWon[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else if tableView == bottomTableView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewPrizeViewController") as! ViewPrizeViewController
            
            vc.giveaway = self.giveawaysLost[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topTableView {
            // active giveaways tableview
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FreebeeTableViewCell
            
            // setting cell properties
            cell.myImageView.image = UIImage(named: giveawaysActive[indexPath.row].image)
            cell.businessLabel.text = giveawaysActive[indexPath.row].advertiserName
            cell.giveawayLabel.text = giveawaysActive[indexPath.row].name
            
            
            // counting down closing date label
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
                cell.closingDateLabel.text = self.giveawaysActive[indexPath.row].dateClosing.dateValue().getTime()
            }
            
            // setting corner radius
            cell.cellView.layer.cornerRadius = 5
            cell.myImageView.layer.cornerRadius = 5
            cell.backgroundColor = UIColor.clear
            
            return (cell)
        }
        else if tableView == winnerTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! FreebeeTableViewCell
            
            // setting cell properties
            cell.myImageView.image = UIImage(named: giveawaysWon[indexPath.row].image)
            cell.businessLabel.text = giveawaysWon[indexPath.row].advertiserName
            cell.giveawayLabel.text = giveawaysWon[indexPath.row].name
            
            // switches from date closing to winner message
            cell.closingDateLabel.text = "YOU WON!! Tap to redeem"
            cell.cellView.layer.cornerRadius = 5
            cell.myImageView.layer.cornerRadius = 5
            cell.backgroundColor = UIColor.clear
            
            cell.cellView.tag = indexPath.row
            
            return cell
        }
        else if tableView == bottomTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! FreebeeTableViewCell
            
            // setting cell properties
            cell.myImageView.image = UIImage(named: giveawaysLost[indexPath.row].image)
            cell.businessLabel.text = giveawaysLost[indexPath.row].advertiserName
            cell.giveawayLabel.text = giveawaysLost[indexPath.row].name
            
            // switches from date closing to the winners name in these cells
            cell.closingDateLabel.text = giveawaysLost[indexPath.row].winner
            cell.cellView.layer.cornerRadius = 5
            cell.myImageView.layer.cornerRadius = 5
            cell.backgroundColor = UIColor.clear
            
            cell.cellView.tag = indexPath.row
            
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    // enables and disables labels and tableviews
    func checkTableViewHeights(){
        if giveawaysActive.count > 0 {
            topTableViewHeightConstraint.constant = CGFloat(cellHeight * giveawaysActive.count)
        } else {
            topTableViewHeightConstraint.constant = 0
        }
        
        if giveawaysWon.count > 0 {
            wonLabelHeightConstraint.constant = 25
            winnerTableViewHeightConstraint.constant = CGFloat(cellHeight * giveawaysWon.count)
        } else {
            wonLabelHeightConstraint.constant = 0
            winnerTableViewHeightConstraint.constant = 0
        }
        
        if giveawaysLost.count > 0 {
            lostLabelHeightConstraint.constant = 25
            bottomTableViewHeightConstraint.constant = CGFloat(cellHeight * giveawaysLost.count)
        } else {
            lostLabelHeightConstraint.constant = 0
            bottomTableViewHeightConstraint.constant = 0
        }
    }
    
    func fetchGiveaways(){
        
        let giveawaysRef = db.collection("giveaways").order(by: "dateClosing")
        giveawaysRef.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(String(describing: document.get("cost")))")
                    
                    // getting active giveaways user is entered in
                    if document.get("active") as! Bool == true {
                        self.giveawaysActive.append(Giveaway(giveawayID: document.documentID, active: (document.get("active") as! Bool), winner: document.get("winner") as! String, name: document.get("name") as! String, cost: document.get("cost") as! String, image: document.get("image") as! String, dateClosing: document.get("dateClosing") as! Timestamp, details: document.get("details") as! String, category: document.get("category") as! String, shareEntries: document.get("shareEntries") as! [String], adEntries: document.get("adEntries") as! [String], location: document.get("location") as! String, code: document.get("code") as! String, advertiserID: document.get("advertiserID") as! String, advertiserName: document.get("advertiserName") as! String)!)}
                        
                        // getting finished giveaways user has lost
                    else if document.get("active") as! Bool == false && document.get("winner") as! String != self.userID {
                        self.giveawaysLost.append(Giveaway(giveawayID: document.documentID, active: (document.get("active") as! Bool), winner: document.get("winner") as! String, name: document.get("name") as! String, cost: document.get("cost") as! String, image: document.get("image") as! String, dateClosing: document.get("dateClosing") as! Timestamp, details: document.get("details") as! String, category: document.get("category") as! String, shareEntries: document.get("shareEntries") as! [String], adEntries: document.get("adEntries") as! [String], location: document.get("location") as! String, code: document.get("code") as! String, advertiserID: document.get("advertiserID") as! String, advertiserName: document.get("advertiserName") as! String)!)}
                        
                        // getting finished giveaways user has won
                    else if document.get("active") as! Bool == false && document.get("winner") as! String == self.userID {
                        self.giveawaysWon.append(Giveaway(giveawayID: document.documentID, active: (document.get("active") as! Bool), winner: document.get("winner") as! String, name: document.get("name") as! String, cost: document.get("cost") as! String, image: document.get("image") as! String, dateClosing: document.get("dateClosing") as! Timestamp, details: document.get("details") as! String, category: document.get("category") as! String, shareEntries: document.get("shareEntries") as! [String], adEntries: document.get("adEntries") as! [String], location: document.get("location") as! String, code: document.get("code") as! String, advertiserID: document.get("advertiserID") as! String, advertiserName: document.get("advertiserName") as! String)!)}
                }
                DispatchQueue.main.async {
                    self.myContentView.isHidden = false
                    self.loadingView.isHidden = true
                    self.checkTableViewHeights()
                    self.reloadTableViews()
                }
            }
        }
    } // end of fetch giveaways func
    
    func reloadTableViews(){
        self.topTableView.reloadData()
        self.winnerTableView.reloadData()
        self.bottomTableView.reloadData()
    }
    
    func setUpLoadingView() {
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(loadingIcon)
        view.addSubview(loadingView)
        view.bringSubviewToFront(loadingView)
        
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.backgroundColor = UIColor.white
        loadingView.layer.cornerRadius = 15
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        loadingLabel.topAnchor.constraint(equalTo: loadingView.topAnchor, constant: 20).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor, constant: -20).isActive = true
        loadingLabel.leftAnchor.constraint(equalTo: loadingView.leftAnchor, constant: 80).isActive = true
        loadingLabel.rightAnchor.constraint(equalTo: loadingView.rightAnchor, constant: -20).isActive = true
        loadingLabel.backgroundColor = UIColor.blue
        loadingLabel.numberOfLines = 2
        loadingLabel.text = "Loading your freebees..."
        loadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        loadingLabel.backgroundColor = UIColor.clear
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loadingIcon.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        loadingIcon.rightAnchor.constraint(equalTo: loadingLabel.leftAnchor, constant: -20).isActive = true
        loadingIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        loadingIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loadingIcon.startAnimating()
        loadingIcon.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    
    
    
}
