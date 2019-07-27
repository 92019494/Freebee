//
//  HomeViewController.swift
//  Freebee
//
//  Created by Anthony on 2/07/19.
//  Copyright © 2019 EmeraldApps. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FBSDKLoginKit



class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var firstTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var myContentView: UIView!
    
    
    let db = Firestore.firestore()
    let layer = CAGradientLayer()
    let userID = "1"
    var loadingView = UIView()
    var loadingLabel = UILabel()
    var loadingIcon = UIActivityIndicatorView(style: .gray)

    var giveaways = [Giveaway]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        // signing in to freebee
        loginToFreebeeWithToken()
        
        
        // retrieving data
        fetchGiveaways()
        
        // adding loading view
        setUpLoadingView()
        
        myContentView.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        view.backgroundColor = UIColor.clear
        
        layer.frame = view.bounds
        layer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        layer.locations = [0.05,1]
        layer.startPoint = CGPoint(x:0.5,y:0)
        layer.endPoint = CGPoint(x:0.5, y:1)
        view.layer.insertSublayer(layer, at: 0)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (giveaways.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WatchListTableViewCell
        
        // setting up cell button
        cell.cellButton.backgroundColor = UIColor.clear
        cell.cellButton.layer.cornerRadius = 20
        cell.cellButton.setTitleColor(UIColor.gray, for: .normal)
        cell.cellButton.layer.borderWidth = 3
        cell.cellButton.layer.borderColor = UIColor.blue.cgColor
        cell.cellButton.tag = indexPath.row
        
        // setting cell labels
        cell.categoryLabel.text = giveaways[indexPath.row].category
        cell.myImageView.image = UIImage(named: giveaways[indexPath.row].image)
        cell.businessLabel.text = giveaways[indexPath.row].advertiserName
        cell.giveawayLabel.text = giveaways[indexPath.row].name
        cell.closingDateLabel.text = giveaways[indexPath.row].dateClosing
        cell.cellView.layer.cornerRadius = 5
        cell.myImageView.layer.cornerRadius = 5
        cell.backgroundColor = UIColor.clear
  
        // checking giveaway status
        if giveaways[indexPath.row].adEntries.contains(self.userID) ||
            giveaways[indexPath.row].shareEntries.contains(self.userID){
            cell.cellButton.layer.borderColor = UIColor.clear.cgColor
            cell.cellButton.setTitle("Entered", for: .normal)
            cell.cellButton.applyGradient(colours: [UIColor.blue, UIColor.purple])
            cell.cellButton.setTitleColor(UIColor.white, for: .normal)
        }
        return (cell)
    }
    
 
    override func viewDidLayoutSubviews() {
        layer.frame = view.bounds
    }
    
    
    @IBAction func EnterToWin(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GiveawayDetailViewController") as! GiveawayDetailViewController
        
        vc.giveaway = giveaways[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setUpLoadingView() {
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(loadingIcon)
        view.addSubview(loadingView)

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
        loadingLabel.text = "Loading the latest freebees..."
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
    
    func fetchGiveaways() {
        
        let giveawaysRef = db.collection("giveaways").order(by: "dateClosing")
        giveawaysRef.getDocuments { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(String(describing: document.get("cost")))")
                    if document.get("active") as! Bool == true {
                        self.giveaways.append(Giveaway(giveawayID: document.documentID, name: document.get("name") as! String, cost: document.get("cost") as! String, image: document.get("image") as! String, dateClosing: document.get("dateClosing") as! String, details: document.get("details") as! String, category: document.get("category") as! String, shareEntries: document.get("shareEntries") as! [String], adEntries: document.get("adEntries") as! [String], location: document.get("location") as! String, advertiserID: document.get("advertiserID") as! String, advertiserName: document.get("advertiserName") as! String)!)}
                }
                DispatchQueue.main.async {
                    self.firstTableView.reloadData()
                    self.firstTableViewHeightConstraint.constant = CGFloat(473 * self.giveaways.count)
                    self.loadingView.isHidden = true
                    self.loadingIcon.stopAnimating()
                }
                
            }
        }
    } // end of fetch giveaways func
    
    // using facebook credentials to sign user in
    func loginToFreebeeWithToken(){
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else
        {return}
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (result, error) in
            if error != nil {
                print("error signing in user", error ?? "" )
                return
            }
            print("Successfully signed in to Freebee", result ?? "" )
        }
        
     
    }

    


    
}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 2000, height: self.bounds.height)
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }

}
