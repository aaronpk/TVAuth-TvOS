//
//  FirstViewController.swift
//  TvOSAuth
//
//  Created by Aaron Parecki on 11/14/15.
//  Copyright © 2015 Esri. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("first view will appear")
    }

    override func viewDidAppear(animated: Bool) {
        let d = NSUserDefaults.standardUserDefaults()
        if(d.boolForKey(kLoginCompleted)) {
            d.removeObjectForKey(kLoginCompleted)
            self.tabBarController?.selectedIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

