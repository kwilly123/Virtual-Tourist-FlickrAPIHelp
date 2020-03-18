//
//  MapViewController.swift
//  VirtualTourist-Udacity
//
//  Created by Kyle Wilson on 2020-03-17.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationData: CLLocationCoordinate2D!
    
    //MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationData = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        view.addGestureRecognizer(longTapGesture)
    }
    
    //MARK: VIEWWILLAPPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: VIEWWILLDISAPPEAR
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: LONG TAP GESTURE
    
    @objc func longTap(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let locationTappedInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationTappedInView, toCoordinateFrom: mapView)
            locationData.latitude = locationOnMap.latitude
            locationData.longitude = locationOnMap.longitude
//            print(locationData.latitude)
            addAnnotation(location: locationOnMap)
            
        }
    }
    
    //MARK: ADD ANNOTATION TO MAP
    
    func addAnnotation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Title"
        annotation.subtitle = "See Location"
        self.mapView.addAnnotation(annotation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AlbumViewController {
            let vc = segue.destination as? AlbumViewController
            vc?.locationRetrieved = locationData
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    //MARK: MAKE PIN
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    //MARK: TAPPED ANNOTATION VIEW
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "segue", sender: locationData)
    }
}
