//
//  AGOResponses.swift
//  TvOSAuth
//
//  Created by Aaron Parecki on 12/9/15.
//  Copyright © 2015 Esri. All rights reserved.
//

import JSONJoy

struct AGOSelfResponse: JSONJoy {
    let fullName: String?
    
    init(_ decoder: JSONDecoder) {
        fullName = decoder["fullName"].string
    }
}

struct AGOItem: JSONJoy {
    let id: String?
    let title: String?
    let type: String?
    init(_ decoder: JSONDecoder) {
        id = decoder["id"].string
        title = decoder["title"].string
        type = decoder["type"].string
    }
    init(t: String) {
        title = t
        id = ""
        type = ""
    }
}

struct AGOUserContentResponse: JSONJoy {
    var items: Array<AGOItem>?
    init(_ decoder: JSONDecoder) {
        if let itms = decoder["items"].array {
            items = Array<AGOItem>()
            for itemDecoder in itms {
                items!.append(AGOItem(itemDecoder))
            }
        }
    }
}
