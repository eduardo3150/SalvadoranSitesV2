//
//  MapaViewController.swift
//  SalvadoranSitesV2
//
//  Created by Eduardo Chavez on 5/11/17.
//  Copyright © 2017 Eduardo Chavez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapasViewController:UIViewController, MKMapViewDelegate {
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var mapType: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var places:[Places]?
    
    let initialLocation = CLLocation(latitude: 13.7371443, longitude: -89.290824)
    let regionRadius: CLLocationDistance = 500000
    var points:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        centerMapOnLocation(initialLocation)
        testLabel.text = places?.first?.categoria
        
        for tmp in places! {
        mapView.addAnnotation(tmp.coord!)
        }
        

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLocationAuth()
    }
    
    
    func centerMapOnLocation(location: CLLocation)  {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkLocationAuth(){
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation)  {
            return nil
        }
        
        let annotationID = "AnnottationID"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationID)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        var pinImage = UIImage(named: "default")
        
        if(places?.first?.categoria=="Playas"){
            pinImage = UIImage(named: "customTwo")
        }
        
        if(places?.first?.categoria=="Sitio Arqueologico"){
            pinImage = UIImage(named: "customOne")
        }
        
        if(places?.first?.categoria=="Bosques y Parques"){
            pinImage = UIImage(named: "customThree")
        }
        
        if(places?.first?.categoria=="Lagos y Lagunas"){
            pinImage = UIImage(named: "customFour")
        }
        
        annotationView!.image = pinImage
        
        return annotationView
        
    }
    
    
    @IBAction func mapTypeChanged(sender: AnyObject) {
        switch mapType.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.Standard
        
        case 1:
            mapView.mapType = MKMapType.Satellite
        
        case 2:
            mapView.mapType = MKMapType.Hybrid
        
        default:
            break
        }
    }
    
}
