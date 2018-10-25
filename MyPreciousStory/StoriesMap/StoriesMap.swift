//
//  StoriesMap.swift
//  MyPreciousStory
//
//  Created by Handy Handy on 19/10/18.
//  Copyright © 2018 Handy Handy. All rights reserved.
//

import MapKit


class StoriesMap {
    
    var dummyStories: [Story]
    
    init() {
        let dummyCoordinate = CLLocationCoordinate2DMake(-6.3047146, 106.6439975)
        self.dummyStories = [Story(title: "Beautiful Morning",coordinate: dummyCoordinate, thumbnail: #imageLiteral(resourceName: "beautiful_morning"))]
    }
    
    func addDummyStories(story: Story) {
        self.dummyStories.append(story)
    }
}


struct Story {
    let title: String
    let coordinate: CLLocationCoordinate2D
    let thumbnail: UIImage
}
