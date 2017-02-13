//
//  ProfileViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/11/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    

    @IBOutlet weak var miscLabel: UILabel!
    
    var attempts = [Attempt]()
    
    
    @IBAction func backToMain(_ sender: Any) {
        
        self.performSegue(withIdentifier: "backToMain", sender: self)
    }
    
    
    @IBAction func logOff(_ sender: Any) {
        
        Model.shared.loggedInUser = nil
        performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    
    @IBAction func editProfile(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: self)
        
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEdit" {
            let profileVC = segue.destination as! OnBoardController
            profileVC.editingMode = true
            
        }
    }
    
    
    func getStats() {
        let userUID = Model.shared.loggedInUser?.uid
        let ref = FIRDatabase.database().reference(withPath: "attempts")
        let query = ref.queryOrdered(byChild: "taker").queryEqual(toValue: userUID)
        query.observeSingleEvent(of: .value, with: updateScore)
    }
    
    
    func updateScore(snapshot: FIRDataSnapshot) {
   
        for child in snapshot.children {
            
            let newAttempt = Attempt(snapshot: child as! FIRDataSnapshot)
            print("added Attempt")
            attempts.append(newAttempt)
            print(attempts.count)
            
            
        }

        let total = attempts.count
        var makes = 0
        
        if total > 0 {
            for attempt in attempts {
                if attempt.success == true {
                    makes += 1
                }
            }
            
        }

        
        miscLabel.text = ("\(makes) / \(total)")
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameLabel.text = Model.shared.loggedInUser?.name
        scoreLabel.text = String(arc4random()%20 * 10) + "pts"
        miscLabel.text = "damn im cool"
        getStats()
        Model.shared.fetchImage(stringURL: (Model.shared.loggedInUser?.avatar)!) { (image) in
            if let retrievedImage = image {
                self.profileImageView.image = retrievedImage.circle
            }
        }
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
