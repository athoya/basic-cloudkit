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
    func saveToTempLocation() throws -> URL? {
        let imageData = self.pngData()
        
        guard let data = imageData else {
            return nil
        }
        
        let filename = ProcessInfo.processInfo.globallyUniqueString + ".png"
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(filename)
        try data.write(to: url, options: .atomic)
        
        return url
    }
}
