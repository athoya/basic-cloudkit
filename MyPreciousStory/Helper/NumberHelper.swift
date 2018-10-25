//
//  NumberHelper.swift
//  MyPreciousStory
//
//  Created by Jazilul Athoya on 22/10/18.
//  Copyright © 2018 Handy Handy. All rights reserved.
//

import Foundation

class NumberHelper {
    
    func getRandomLatLong() -> (Double, Double) {
        let rand = arc4random_uniform(10)
        let multiplier: Double = Double(rand) / 1000
        
        let lat = -6.3047146 + multiplier
        let lon = 106.6439975 + multiplier
        
        return (lat, lon)
    }
    
}
