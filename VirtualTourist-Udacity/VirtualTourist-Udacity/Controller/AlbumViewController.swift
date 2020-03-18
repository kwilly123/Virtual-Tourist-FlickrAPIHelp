//
//  AlbumViewController.swift
//  VirtualTourist-Udacity
//
//  Created by Kyle Wilson on 2020-03-17.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit
import MapKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollection: UIToolbar!
    
    var locationRetrieved: CLLocationCoordinate2D?
    
    var image: UIImage?
    
    //MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        print(locationRetrieved)
        if let location = locationRetrieved {
            pin(coordinate: location)
        } else {
            print("no location")
        }
    }
    
    //MARK: VIEWWILLAPPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: GEOCODE LOCATION
    
    func pin(coordinate: CLLocationCoordinate2D) {
        activityIndicator.startAnimating()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func downloadPhotos() {
        FlickrClient.searchPhotos(lat: locationRetrieved!.latitude, lon: locationRetrieved!.longitude, totalPageAmt: 20) { (photos, pages, error) in
            
        }
    }

}

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}

extension AlbumViewController: MKMapViewDelegate {
    //MARK: MAKE PIN
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}


