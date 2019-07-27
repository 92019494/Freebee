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
    let layer = CAGradientLayer()
    var cellHeight = 144
    var loadingView = UIView()
    var loadingLabel = UILabel()
    var loadingIcon = UIActivityIndicatorView(style: .gray)
    
    @IBOutlet weak var lostLabel: UILabel!
    @IBOutlet weak var lostLabelHeightConstraint: NSLayoutConstraint!
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

        // modifying navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        // modifying content view
        myContentView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear

        // setting background gradient colour
        layer.frame = view.bounds
        layer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        layer.locations = [0.05,1]
        layer.startPoint = CGPoint(x:0.5,y:0)
        layer.endPoint = CGPoint(x:0.5, y:1)
        view.layer.insertSublayer(layer, at: 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topTableView {
            return (giveawaysActive.count)
        } else if tableView == bottomTableView {
            return (giveawaysLost.count)
        } else {
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == topTableView {
        // active giveaways tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FreebeeTableViewCell
        
            
        cell.myImageView.image = UIImage(named: giveawaysActive[indexPath.row].image)
        cell.businessLabel.text = giveawaysActive[indexPath.row].advertiserName
        cell.giveawayLabel.text = giveawaysActive[indexPath.row].name
        cell.closingDateLabel.text = giveawaysActive[indexPath.row].dateClosing
        cell.cellView.layer.cornerRadius = 5
        cell.myImageView.layer.cornerRadius = 5
        cell.backgroundColor = UIColor.clear
    
    
        return (cell)
        }
        else if tableView == bottomTableView {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! FreebeeTableViewCell
            
        cell.myImageView.image = UIImage(named: giveawaysLost[indexPath.row].image)
        cell.businessLabel.text = giveawaysLost[indexPath.row].advertiserName
        cell.giveawayLabel.text = giveawaysLost[indexPath.row].name
        cell.closingDateLabel.text = giveawaysLost[indexPath.row].dateClosing
        cell.cellView.layer.cornerRadius = 5
        cell.myImageView.layer.cornerRadius = 5
        cell.backgroundColor = UIColor.clear
            
        return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func viewDidLayoutSubviews() {
        layer.frame = view.bounds
    }
    

    func checkTableViewHeights(){
        if giveawaysActive.count > 0 {
            topTableViewHeightConstraint.constant = CGFloat(cellHeight * giveawaysActive.count + 25)
        } else {
            topTableViewHeightConstraint.constant = 0
        }
        
        if giveawaysLost.count > 0 {
            lostLabelHeightConstraint.constant = 25
            bottomTableViewHeightConstraint.constant = CGFloat(cellHeight * giveawaysLost.count + 25)
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
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(String(describing: document.get("cost")))")
                    
                    if document.get("active") as! Bool == true {
                        self.giveawaysActive.append(Giveaway(giveawayID: document.documentID, name: document.get("name") as! String, cost: document.get("cost") as! String, image: document.get("image") as! String, dateClosing: document.get("dateClosing") as! String, details: document.get("details") as! String, category: document.get("category") as! String, shareEntries: document.get("shareEntries") as! [String], adEntries: document.get("adEntries") as! [String], location: document.get("location") as! String, advertiserID: document.get("advertiserID") as! String, advertiserName: document.get("advertiserName") as! String)!)
                    }
                    else if document.get("active") as! Bool == false {
                         self.giveawaysLost.append(Giveaway(giveawayID: document.documentID, name: document.get("name") as! String, cost: document.get("cost") as! String, image: document.get("image") as! String, dateClosing: document.get("dateClosing") as! String, details: document.get("details") as! String, category: document.get("category") as! String, shareEntries: document.get("shareEntries") as! [String], adEntries: document.get("adEntries") as! [String], location: document.get("location") as! String, advertiserID: document.get("advertiserID") as! String, advertiserName: document.get("advertiserName") as! String)!)
                    }
                }
                DispatchQueue.main.async {
                    self.myContentView.isHidden = false
                    self.loadingView.isHidden = true
                    self.checkTableViewHeights()
                    self.topTableView.reloadData()
                    self.bottomTableView.reloadData()
                }
            }
        }
    } // end of fetch giveaways func
 
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
