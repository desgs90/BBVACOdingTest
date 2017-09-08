//
//  NetworkManager.swift
//  BBVACompass
//
//  Created by Diego Eduardo on 9/8/17.
//  Copyright © 2017 Diego Santiago. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate: class {
    
    func didGetInfo()
}

class NetworkManager: NSObject {
    
    //MARK:- Vars
    lazy var compassDao = BBVACompassModuleDao.instance
    weak var delegate: NetworkManagerDelegate?
    fileprivate static let api = "AIzaSyBcALMXoaxF7Pcl9hoiDjlUUl9beFXyAtk"
    
    
    func getLocations(_ lat: String, lon: String) {
    let stringURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=BBVA+Compass&location=\(lat),\(lon)&radius=10000&key=\(NetworkManager.api)"
        let url = URL(string: stringURL)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] {
                        //checkResponseError
                        if let _ = jsonObject["error_message"] as? String, let status = jsonObject["status"] as? String {
                            print("Error in response: \(status)")
                            return
                        }
                        guard let results = jsonObject["results"] as? [[String: Any]] else { return}
                        //ParseInfo
                        self.compassDao.parseData(results)
                        DispatchQueue.main.async {
                            self.delegate?.didGetInfo()
                        }
                    }
                } catch {
                    
                }
            }
        }
        task.resume()
    }
}
