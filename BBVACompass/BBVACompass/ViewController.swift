//
//  ViewController.swift
//  BBVACompass
//
//  Created by Diego Eduardo on 9/8/17.
//  Copyright © 2017 Diego Santiago. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    //MARK:- IBOUtlets
    
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Public var
    var networkManager = NetworkManager()
    var locManager = CLLocationManager()
    lazy var bbvaModuleInstance = BBVACompassModuleDao.instance
    
    var placeSelected: BBVACompassModule?
    
    var tablePlaces = [BBVACompassModule]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Location SetUp
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        
        //Network SetUp
        networkManager.delegate = self
        
        //TableView SetUp
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        let nib1 = UINib(nibName: "PlaceCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "PlaceCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    fileprivate func setLocation() {
        guard let location: CLLocation = locManager.location else { return }
        centerMap(location)
        networkManager.getLocations(String(describing: location.coordinate.latitude), lon: String(describing: location.coordinate.longitude))
    }
    
    fileprivate func updateData() {
        let newItems = bbvaModuleInstance.getPlaces()
        
        updateAnnotations(newItems)
        updateTableView(newItems)
        
    }
    
    fileprivate func centerMap(_ location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        
        let cordinate = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius , regionRadius)
        mapKit.setRegion(cordinate, animated: true)        
    }
    
    fileprivate func updateAnnotations(_ items: [BBVACompassModule]) {

        //cleanMap
        removeAnnotations()
        
        var annotations = [MKPointAnnotation]()
        for item in items {
            let annotation = CustomAnnotation()
            
            annotation.title = item.name
            annotation.subtitle = item.openNow ? "Open":"Closed"
            annotation.coordinate = CLLocationCoordinate2D(latitude: item.lat, longitude: item.lon)
            annotations.append(annotation)
            annotation.id = item.id
        }
        mapKit.addAnnotations(annotations)
    }
    
    fileprivate func updateTableView(_ items: [BBVACompassModule]) {
        tablePlaces = items
        tableView.reloadData()
    }
    
    fileprivate func removeAnnotations() {
        let currentAnnotations = mapKit.annotations
        mapKit.removeAnnotations(currentAnnotations)
    }
    
    //MARK:- Actions
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
    
        if segment.selectedSegmentIndex == 0 {
            tableView.isHidden = true
            
        } else if segment.selectedSegmentIndex == 1 {
            tableView.isHidden = false
        }
        
    }
    
    @IBAction func locationAction(_ sender: UIBarButtonItem) {
        setLocation()
    }
    
    //MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaceDetail" {
            let vc = segue.destination as! PlaceDetailViewController
            vc.placeSelected = placeSelected
        }
    }
}

//MARK:- Delegate Networking

extension ViewController: NetworkManagerDelegate {
    
    func didGetInfo() {
        updateData()
    }
}

//MARK:- Delegate Location

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    setLocation()
                }
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "CustomAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "mapPin")
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        //add Detail
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "info"), for: .normal)
        annotationView?.rightCalloutAccessoryView = button
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
        //set placeSelectedNil to get new one
        placeSelected = nil
        let annotationSelected = view.annotation as! CustomAnnotation
        let id = annotationSelected.id
        if !(id.isEmpty) {
            let places = bbvaModuleInstance.getPlaces()
            
            for place in places {
                if place.id == id {
                    placeSelected = place
                    performSegue(withIdentifier: "showPlaceDetail", sender: nil)
                    return
                }
            }
        }
    }
}

//MARK:- Table View Delegates and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tablePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell") as! PlaceCell
        
        let place = tablePlaces[indexPath.row]
        
        cell.name.text = place.name
        cell.detail.text = place.openNow ? "Open":"Closed"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        placeSelected = tablePlaces[indexPath.row]
        performSegue(withIdentifier: "showPlaceDetail", sender: nil)
    }
    
}
class CustomAnnotation: MKPointAnnotation {
    public var id = ""
}
