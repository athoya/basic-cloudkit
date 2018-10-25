//
//  UIImageView+Extenstion.swift
//  CloudKitExample1
//
//  Created by Jazilul Athoya on 18/10/18.
//  Copyright © 2018 Jazilul Athoya. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func saveToTemporaryLocation() throws -> URL {
        let imageData = self.pngData()
        
        let filename = "\(Date().timeIntervalSince1970)" + ".png"
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        try imageData?.write(to: url, options: .atomic)
        
        return url
    }
}
