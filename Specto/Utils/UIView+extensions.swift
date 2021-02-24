//
//  UIView+extensions.swift
//  Specto
//
//  Created by Moeen Zamani on 2/24/21.
//

import Foundation
import SwiftUI

extension UIView {
    func asImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}
