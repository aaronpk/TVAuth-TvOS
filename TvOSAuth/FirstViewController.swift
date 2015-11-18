//
//  FirstViewController.swift
//  TvOSAuth
//
//  Created by Aaron Parecki on 11/14/15.
//  Copyright © 2015 Esri. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

struct CodeResponse: JSONJoy {
    let device_code: String?
    let user_code: String?
    let verification_uri: String?
    let interval: Int?
    init(_ decoder: JSONDecoder) {
        device_code = decoder["device_code"].string
        user_code = decoder["user_code"].string
        verification_uri = decoder["verification_uri"].string
        interval = decoder["interval"].integer
    }
}

struct TokenResponse: JSONJoy {
    let access_token: String?
    init(_ decoder: JSONDecoder) {
        access_token = decoder["access_token"].string
    }
}

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInWasTapped(sender: AnyObject) {
        // Make an HTTP request to request a device code
        let params = ["response_type":"device_code", "client_id":"Cdk0dzPrsljHRy6z"]
        do {
            let opt = try HTTP.POST("https://tvauth.pin13.net/device/code", parameters: params)
            opt.start { response in
                let code = CodeResponse(JSONDecoder(response.data))
                if let user_code = code.user_code {
                    print("got user code: \(user_code)")
                    print(code)
                } else {
                    print("error getting code: \(response.data)")
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }

}

