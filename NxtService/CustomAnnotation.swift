//
//  CustomAnnotation.swift
//  NxtService
//
//  Created by Emanuel  Guerrero on 4/27/16.
//  Copyright © 2016 Project Omicron. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}