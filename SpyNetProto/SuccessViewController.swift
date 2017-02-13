//
//  SuccessViewController.swift
//  SpyNetProto
//
//  Created by Edward Han on 2/12/17.
//  Copyright © 2017 Edward Han. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    enum ResultAttempt {
        case success
        case failed
        case inconclusive
    }
    
    
    var result: ResultAttempt?
    
    
    func done() {
        sleep(2)
        print("in done")
        self.view.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if result == .success {
            resultLabel.text = "SUCCESS"
            resultLabel.backgroundColor = UIColor.green
        }
        
        if result == .failed {
            resultLabel.text = "Attempt Failed"
            resultLabel.backgroundColor = UIColor.red
        }
        
        if result == .inconclusive {
                resultLabel.text = "inconclusive, more analysis necessary"
                resultLabel.backgroundColor = UIColor.yellow
            }
        
        done()
        
        
        
        
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
