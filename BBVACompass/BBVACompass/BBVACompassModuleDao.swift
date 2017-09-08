//
//  BBVACompassModuleDao.swift
//  BBVACompass
//
//  Created by Diego Eduardo on 9/8/17.
//  Copyright © 2017 Diego Santiago. All rights reserved.
//

import Foundation

class BBVACompassModuleDao: NSObject {
    public static let instance = BBVACompassModuleDao()
    
     fileprivate var masterPlaces = [BBVACompassModule]()
    
    public func parseData(_ data: [[String:Any]]) {
        // all the time we parse new info delete the last data
        masterPlaces.removeAll()
        
        for item in data {
            //Gen vars
            var lat = 0.0
            var lon = 0.0
            var openNow = false
            
            let id: String = item["id"] as? String ?? ""
            let address: String = item["formatted_address"] as? String ?? ""
            //geometryforLatandLon
            
            if let geometry = item["geometry"] as? [String: Any] {
                if let location = geometry["location"] as? [String: Any] {
                    lat = location["lat"] as? Double ?? 0.0
                    lon = location["lng"] as? Double ?? 0.0
                }
            }
            let iconUrl: String = item["icon"] as? String ?? ""
            let name: String = item["name"] as? String ?? ""
            //OpeningHours to get open Now
            if let openingHours = item["opening_hours"] as? [String: Any] {
                openNow = openingHours["open_now"] as? Bool ?? false
            }
            let rating: Double = item["rating"] as? Double ?? 0.0
            let types: [String] = item["types"] as? [String] ?? []
            
            let bbvaModule = BBVACompassModule(id: id, address: address, lat: lat, lon: lon, iconUrl: iconUrl, name: name, openNow: openNow, rating: rating, types: types)
            masterPlaces.append(bbvaModule)

        }
    }
 
    public func getPlaces() -> [BBVACompassModule] {
        return masterPlaces
    }

}
