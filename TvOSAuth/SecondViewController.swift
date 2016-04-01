//
//  SecondViewController.swift
//  TvOSAuth
//
//  Created by Aaron Parecki on 11/14/15.
//  Copyright © 2015 Esri. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var items = [AGOItem]()

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.usernameLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let token = NSUserDefaults.standardUserDefaults().stringForKey(kAccessTokenDefaults)
        if(token != nil) {
            let username = NSUserDefaults.standardUserDefaults().stringForKey(kUsernameDefaults)

            do {
                let opt = try HTTP.GET("https://www.arcgis.com/sharing/rest/community/self", parameters: ["f": "json", "token": token!])
                opt.start { response in
                    print("\(NSString(data:response.data, encoding:NSUTF8StringEncoding))")
                    let agoSelf = AGOSelfResponse(JSONDecoder(response.data))
                    print("Welcome \(agoSelf.fullName)")
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.usernameLabel.text = agoSelf.fullName
                        }
                    }
                }

                let opt2 = try HTTP.GET("https://www.arcgis.com/sharing/rest/content/users/\(username!)", parameters: ["f": "json", "token": token!])
                opt2.start { response in
                    let content = AGOUserContentResponse(JSONDecoder(response.data))
                    self.items = content.items!
                    self.tableView.reloadData()
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }

            
        }
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell", forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = items[indexPath.row]
        
        cell.titleLabel.text = item.title!
        cell.descriptionLabel.text = item.type!
        
        print("Created cell: \(item.title!)")
        
        return cell
    }

    func loadItems() {
        let item1 = AGOItem(t: "One")
        let item2 = AGOItem(t: "Two")
        items += [item1, item2]
    }

}

