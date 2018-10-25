//
//  StoriesAnnotation.swift
//  MyPreciousStory
//
//  Created by Handy Handy on 20/10/18.
//  Copyright © 2018 Handy Handy. All rights reserved.
//

import MapKit

class StoriesAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var titleVideo: String!
    var thumbnailVideo: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}
