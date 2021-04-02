//
//  UIImage+Ext.swift
//  PokeApp
//
//  Created by Кирилл Романенко on 02.04.2021.
//

import UIKit

extension UIImage {
    var url: URL? {
        let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("TempImage.png")
        do {
            try self.pngData()?.write(to: imageURL!)
        } catch {
            print("write error: \(error.localizedDescription)")
        }
        return imageURL
    }
}
