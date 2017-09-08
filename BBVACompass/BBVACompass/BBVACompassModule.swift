//
//  BBVACompassModule.swift
//  BBVACompass
//
//  Created by Diego Eduardo on 9/8/17.
//  Copyright © 2017 Diego Santiago. All rights reserved.
//

import Foundation

class BBVACompassModule: NSObject {
    public var id: String
    public var address: String
    public var lat: Double
    public var lon: Double
    public var iconUrl: String
    public var name: String
    public var openNow: Bool
    public var rating: Double
    public var types: [String]
    
    public init(id:String, address: String, lat: Double, lon: Double, iconUrl: String, name: String, openNow: Bool, rating: Double, types:[String]) {
        self.id = id
        self.address = address
        self.lat = lat
        self.lon = lon
        self.iconUrl = iconUrl
        self.name = name
        self.openNow = openNow
        self.rating = rating
        self.types = types
    }
}
