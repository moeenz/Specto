//
//  UIImage+extensions.swift
//  Specto
//
//  Created by Moeen Zamani on 2/24/21.
//

import SwiftUI

extension UIImage {
    func circle() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width * self.scale, height: size.height * self.scale)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let result = renderer.image { c in
            let isPortrait = size.height > size.width
            let isLandscape = size.width > size.height
            let breadth = min(size.width * scale, size.height * scale)
            let breadthSize = CGSize(width: breadth, height: breadth)
            let breadthRect = CGRect(origin: .zero, size: breadthSize)
            let origin = CGPoint(x: isLandscape ? floor((size.width - size.height) * scale / 2) : 0,
                                 y: isPortrait  ? floor((size.height - size.width) * scale / 2) : 0)
            let circle = UIBezierPath(ovalIn: breadthRect)
            circle.addClip()
            if let cgImage = self.cgImage?.cropping(to: CGRect(origin: origin, size: breadthSize)) {
                UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation).draw(in: rect)
            }
        }
        return result
    }
}
