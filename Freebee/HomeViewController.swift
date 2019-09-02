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
    

    @IBOutlet weak var firstTableView: UITableView!
    @IBOutlet weak var myContentView: UIView!
    
    
    @IBOutlet weak var firstTableViewHeightConstraint: NSLayoutConstraint!
    let db = Firestore.firestore()

    var loadingView = UIView()
    var loadingLabel = UILabel()
    var loadingIcon = UIActivityIndicatorView(style: .gray)

    var giveaways = [Giveaway]()

    var user = User(name: "", phoneNumber: "", address: "", region: "", age: "", email: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        // signing in to freebee
        loginToFreebeeWithToken()
        
        
        // retrieving data
        fetchGiveaways()
        
        // getting user
        fetchUser()
        
        // adding loading view
        setUpLoadingView()
        
        
        //setting up navigation controller
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.blue
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        
        // adding gradient to view
        view.backgroundColor = UIColor.clear
        myContentView.backgroundColor = UIColor.clear
        let gradientView = GradientView(frame: self.view.bounds)
        view.insertSubview(gradientView, at: 0)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (giveaways.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WatchListTableViewCell

        // setting tag for later
        cell.cellButton.tag = indexPath.row
        
        // setting up cell button
        cell.cellButton.backgroundColor = UIColor.clear
        cell.cellButton.layer.cornerRadius = cell.cellButton.bounds.height / 2
        cell.cellButton.setTitleColor(UIColor.gray, for: .normal)
        
        // setting cell labels
        cell.categoryLabel.text = giveaways[indexPath.row].category
        cell.myImageView.image = UIImage(named: giveaways[indexPath.row].image)
        cell.businessLabel.text = giveaways[indexPath.row].advertiserName
        cell.giveawayLabel.text = giveaways[indexPath.row].name
        
        
        // counting down closing date label
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            cell.closingDateLabel.text = self.giveaways[indexPath.row].dateClosing.dateValue().getTime()
        }
  
        // setting corner radius
        cell.cellView.layer.cornerRadius = 10
        cell.myImageView.layer.cornerRadius = 10
        cell.backgroundColor = UIColor.clear
        

        // checking giveaway status
        if giveaways[indexPath.row].adEntries.contains(self.user?.email ?? "123") ||
            giveaways[indexPath.row].shareEntries.contains(self.user?.email ?? "123"){
            
            // applying button gradient
            cell.cellButton.layer.borderColor = UIColor.clear.cgColor
            cell.cellButton.setTitle("Entered", for: .normal)
            cell.cellButton.applyButtonGradient()
            cell.cellButton.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            // applying button border
            cell.cellButton.layer.borderWidth = 4
            cell.cellButton.layer.borderColor = UIColor(red: 74/255, green: 0/255, blue: 224/255, alpha: 1).cgColor
            
            
           
        }
        return (cell)
    }
    
    override func viewDidLayoutSubviews() {
      
    }
    

    @IBAction func EnterToWin(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "GiveawayDetailViewController") as! GiveawayDetailViewController
        
        vc.user = self.user
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
                        self.giveaways.append(Giveaway(giveawayID: document.documentID, active: (document.get("active") as! Bool), winner: document.get("winner") as! String, name: document.get("name") as! String, cost: document.get("cost") as! String, image: document.get("image") as! String, dateClosing: document.get("dateClosing") as! Timestamp, details: document.get("details") as! String, category: document.get("category") as! String, shareEntries: document.get("shareEntries") as! [String], adEntries: document.get("adEntries") as! [String], location: document.get("location") as! String, code: document.get("code") as! String, advertiserID: document.get("advertiserID") as! String, advertiserName: document.get("advertiserName") as! String)!)}
                }
                DispatchQueue.main.async {
                    self.firstTableView.reloadData()
                    self.firstTableViewHeightConstraint.constant = CGFloat(445 * self.giveaways.count)
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
    
    func fetchUser() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        print(userEmail)
        let usersRef = db.collection("users")
        usersRef.getDocuments { (snapshot, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            for document in snapshot!.documents {
                if document.get("email") as! String == userEmail {
                    self.user = User(name: document.get("name") as! String, phoneNumber: document.get("phoneNumber") as! String, address: document.get("address") as! String, region: document.get("region") as! String, age: document.get("age") as! String, email: userEmail)
                
                    break
                }
            }
            print("user details are ...")
            print(self.user?.name)
            print(self.user?.age)
            print(self.user?.phoneNumber)
            print(self.user?.email)

        }
    }
    
}








extension UIView {
    
    func applyGradient(layer: CAGradientLayer){
        layer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        layer.colors = [UIColor(red: 74/255, green: 0/255, blue: 224/255, alpha: 1).cgColor, UIColor(red: 142/255, green: 45/255, blue: 226/255, alpha: 1).cgColor]
    layer.locations = [0.05,0.8]
    layer.startPoint = CGPoint(x:0.5,y:0)
    layer.endPoint = CGPoint(x:0.5, y:1)
    self.layer.insertSublayer(layer, at: 0)
    }
    
    func applyButtonGradient(){
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 3000, height: self.bounds.height)
        layer.colors = [UIColor(red: 74/255, green: 0/255, blue: 224/255, alpha: 1).cgColor, UIColor(red: 142/255, green: 45/255, blue: 226/255, alpha: 1).cgColor]
        layer.locations = [0.05,0.8]
        layer.startPoint = CGPoint(x:0.5,y:0)
        layer.endPoint = CGPoint(x:0.5, y:1)
        self.layer.insertSublayer(layer, at: 0)
    }

}

extension UIButton {
    
    func applyBorder(layer: CAGradientLayer, shape: CAShapeLayer){
        
        layer.frame =  CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        layer.colors = [UIColor(red: 74/255, green: 0/255, blue: 224/255, alpha: 1).cgColor, UIColor(red: 200/255, green: 45/255, blue: 226/255, alpha: 1).cgColor]
        
       
        shape.lineWidth = 10
        shape.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height), cornerRadius: self.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        layer.mask = shape
        
        self.layer.addSublayer(layer)
        

        
    }
    
}
