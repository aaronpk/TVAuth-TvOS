//
//  APIResponses.swift
//  TvOSAuth
//
//  Created by Aaron Parecki on 11/18/15.
//  Copyright © 2015 Esri. All rights reserved.
//

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
    let error: String?
    let access_token: String?
    let expires_in: Int?
    let username: String?
    let refresh_token: String?
    init(_ decoder: JSONDecoder) {
        error = decoder["error"].string
        access_token = decoder["access_token"].string
        expires_in = decoder["expires_in"].integer
        username = decoder["username"].string
        refresh_token = decoder["refresh_token"].string
    }
}
