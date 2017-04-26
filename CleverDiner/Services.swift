//
//  Services.swift
//  CleverDiner
//
//  Created by admin on 4/20/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

class Services: NSObject {
    
    static let sharedInstance = Services()
        
    func performSearch(searchLocation: CLLocation, searchString: String, mapView: MKMapView, completion: @escaping (MKMapView, [MKMapItem]) ->()) {
        
        var places = [MKMapItem]()
        
        let midpointCoord = CLLocationCoordinate2D(latitude: searchLocation.coordinate.latitude, longitude: searchLocation.coordinate.longitude)
        
        // set search region to be a square with an area of half the distance between the 2 users
        let midpointRegionSpan = MKCoordinateSpanMake(2000, 2000)
        let midpointRegion = MKCoordinateRegionMakeWithDistance(midpointCoord, midpointRegionSpan.latitudeDelta, midpointRegionSpan.longitudeDelta)
        
        // use MKLocalSearch API to find places
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchString
        request.region = midpointRegion
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(String(describing: error))")
                return
            }
            
            // add place to map and list
            for place in response.mapItems {
                
                places.append(place)
                
                let placeAnno = MKPointAnnotation()
                placeAnno.coordinate = place.placemark.coordinate
                placeAnno.title = place.name
                mapView.addAnnotation(placeAnno)
                completion(mapView, places)
            }
        }
    }
}
