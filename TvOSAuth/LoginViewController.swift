//
//  LoginViewController.swift
//  TvOSAuth
//
//  Created by Aaron Parecki on 11/18/15.
//  Copyright © 2015 Esri. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class LoginViewController : UIViewController {
    @IBOutlet weak var connectingMsg: UILabel!
    @IBOutlet weak var msg1: UILabel!
    @IBOutlet weak var msg2: UILabel!
    @IBOutlet weak var verificationURL: UILabel!
    @IBOutlet weak var userCode: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var tokenTimer: NSTimer!
    var code: CodeResponse!
    
    override func viewWillAppear(animated: Bool) {
        connectingMsg.hidden = false
        msg1.hidden = true
        msg2.hidden = true
        verificationURL.hidden = true
        userCode.hidden = true
        spinner.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        // Make an HTTP request to request a device code
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let params = [
                "response_type": "device_code",
                "client_id": OAuthClientID
            ]
            do {
                let opt = try HTTP.POST(OAuthDeviceCodeEndpoint, parameters: params)
                opt.start { response in
                    let code = CodeResponse(JSONDecoder(response.data))
                    if let user_code = code.user_code {
                        print("got user code: \(user_code)")
                        print(code)
                        self.showUserCode(code)
                    } else {
                        print("error getting code: \(response.data)")
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
            }
        }
    }
    
    func showUserCode(code: CodeResponse) {
        self.code = code
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                // update the UI on the main thread
                self.verificationURL.text = code.verification_uri
                self.userCode.text = code.user_code
                
                self.connectingMsg.hidden = true
                self.msg1.hidden = false
                self.msg2.hidden = false
                self.verificationURL.hidden = false
                self.userCode.hidden = false
                self.spinner.hidden = false
                
                // start a timer to check for the access token
                self.checkForTokenAfterDelay()
            }
        }
    }
    
    func checkForTokenAfterDelay() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                NSTimer.scheduledTimerWithTimeInterval((Double)(self.code.interval!), target: self, selector: "requestAccessToken", userInfo: nil, repeats: false)
            }
        }
    }
    
    func dismissLoginScreen() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion:nil)
            }
        }
    }
    
    func requestAccessToken() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // Poll the token endpoint
            let params = [
                "grant_type": "authorization_code",
                "client_id": OAuthClientID,
                "code": self.code.device_code!
            ]
            do {
                let opt = try HTTP.POST(OAuthTokenEndpoint, parameters: params)
                opt.start { response in
                    let token = TokenResponse(JSONDecoder(response.data))
                    if let error = token.error {
                        print("got status: \(error)")
                        if error == "authorization_pending" {
                            // keep polling
                            self.checkForTokenAfterDelay()

                        } else {
                            print("stopping polling")
                            self.dismissLoginScreen()
                        }
                    } else if token.access_token != nil {
                        print("got an access token! \(token.access_token)")
                        NSUserDefaults.standardUserDefaults().setObject(token.access_token, forKey: kAccessTokenDefaults)
                        print("stopping polling")
                        self.dismissLoginScreen()
                    } else {
                        print("error getting token: \(response.statusCode) \(response.text)")
                        self.dismissLoginScreen()
                    }
                }
            } catch let error {
                print("got an error creating the request: \(error)")
                self.dismissLoginScreen()
            }
        }
    }
}