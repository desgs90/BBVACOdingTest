//
//  PlaceDetailViewController.swift
//  BBVACompass
//
//  Created by Diego Eduardo on 9/8/17.
//  Copyright © 2017 Diego Santiago. All rights reserved.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
    //MARK:- IBOUtlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Vars
    var placeSelected: BBVACompassModule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = placeSelected?.name
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- Table View Delegate and DataSource
extension PlaceDetailViewController: UITableViewDelegate,UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        let cell = UITableViewCell()
        
        var titleString = ""
        
        switch section {
        case 0:
            titleString = (placeSelected?.name)!//"  Name"
        case 1:
            titleString = (placeSelected?.address)!//"  Address"
            cell.textLabel?.numberOfLines = 2
        case 2:
            titleString = (placeSelected?.openNow)! ? "Open":"Closed"
        case 3:
            titleString = String(describing: placeSelected?.rating)
            if let ps = placeSelected {
                titleString = String(describing: ps.rating)
            }
        case 4:
            for item in (placeSelected?.types)! {
                titleString.append("\(item)\n")
            }
            cell.textLabel?.numberOfLines = 10
        default:
            titleString = "  Info"
        }

        cell.textLabel?.text = titleString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        
        if section == 4 {
            let types = placeSelected?.types.count
            return CGFloat(types! * 35) + 40
        }
        return 60
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        
        title.textColor = UIColor.darkGray
        title.backgroundColor = UIColor.groupTableViewBackground
        title.font = UIFont.systemFont(ofSize: 16)
        
        var titleString = ""
        
        switch section {
        case 0:
            titleString = "  Name"
        case 1:
            titleString = "  Address"
        case 2:
            titleString = "  OpenNow"
        case 3:
            titleString = "  Rating"
        case 4:
             titleString = " Types"
        default:
            titleString = "  Info"
            
        }
        title.text = titleString
        return title
    }
    
}
