//
//  MapViewController.swift
//  NxtService
//
//  Created by Emanuel Guerrero on 4/28/16.
//             Shaquella Dunanson
//             Santago Facuno
//             Jevin Francis
//             Marcus Guerrer
//             Stephen Green
//             Ryan Fernandez on 4/28/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var getDirections: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var points:[CLLocationCoordinate2D] = []
    var providerAddress: String!
    var userLocation: String!
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        getPlacemarkFromAddress(providerAddress)
        getPlacemarkFromAddress(userLocation)
    }
    
    // MARK: - Events
    @IBAction func backButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func getDirectionsButtonTapped() {
        let alert = UIAlertController(title: "Open Apple Maps", message: "Open Apple Maps?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) in
            self.openAppleMaps()
        }
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helper methods
    func createAnnotationForLocation(location: CLLocation) {
        dispatch_async(dispatch_get_main_queue()) { 
            let customAnnotation = CustomAnnotation(coordinate: location.coordinate)
            self.mapView.addAnnotation(customAnnotation)
            self.points.append(location.coordinate)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        dispatch_async(dispatch_get_main_queue()) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, Double(1000 * 2), Double(1000 * 2))
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func getPlacemarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) in
            guard let marks = placemarks where marks.count > 0 else { return }
            guard let location = marks[0].location else { return }
            
            self.createAnnotationForLocation(location)
            
            if address == self.userLocation {
                self.centerMapOnLocation(location)
            }
        }
    }
    
    func openAppleMaps() {
        CLGeocoder().geocodeAddressString(userLocation) { (placemarks: [CLPlacemark]?, error: NSError?) in
            guard let marks = placemarks where marks.count > 0 else { return }
            guard let placeMark = marks.first else { return }
            
            let mapPlacemark = MKPlacemark(placemark: placeMark)
            let mapItem = MKMapItem(placemark: mapPlacemark)
            //mapItem.openInMapsWithLaunchOptions(launchOptions)
            
            CLGeocoder().geocodeAddressString(self.providerAddress, completionHandler: { (placemarks: [CLPlacemark]?, error: NSError?) in
                guard let marks2 = placemarks where marks2.count > 0 else { return }
                guard let placeMark2 = marks2.first else { return }
                
                let mapPlacemark2 = MKPlacemark(placemark: placeMark2)
                let mapItem2 = MKMapItem(placemark: mapPlacemark2)
                
                let mapItems = [mapItem, mapItem2]
                let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                MKMapItem.openMapsWithItems(mapItems, launchOptions: launchOptions)
            })
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(CustomAnnotation) {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "default")
            
            
            if annotation.coordinate.latitude == points[0].latitude && annotation.coordinate.longitude == points[0].longitude {
                annotationView.pinTintColor = UIColor(red: 62.0 / 255.0, green: 180.0 / 255.0, blue: 137.0 / 255.0, alpha: 1.0)
            } else {
                annotationView.pinTintColor = UIColor.redColor()
            }
            
            annotationView.animatesDrop = true
            
            return annotationView
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKindOfClass(MKPolyline) {
            let polyLineRender = MKPolylineRenderer(overlay: overlay)
            polyLineRender.strokeColor = UIColor.blueColor()
            polyLineRender.lineWidth = 2
            
            return polyLineRender
        }
        
        return MKOverlayRenderer()
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        let polyLine = MKPolyline(coordinates: &self.points, count: self.points.count)
        self.mapView.addOverlay(polyLine, level: .AboveRoads)
    }
}