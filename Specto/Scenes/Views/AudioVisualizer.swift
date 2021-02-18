//
//  AudioVisualizer.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

struct AudioVisualizer: View {
    // This view receives the amplitudes and renders the spectogram
    
    var amplitudes :  [[Double]]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(0 ..< self.amplitudes.count, id: \.self) { number in
                    
                    vinylView(center: CGPoint(x: geometry.size.width / 2, y:geometry.size.height / 2),
                              radius: geometry.size.width / 2,
                              insideRadius: geometry.size.width / 7,
                              amplitudes: self.amplitudes[number],
                              sector: CGFloat(number),
                              sectorCount: 50.0)
                }
            }.drawingGroup()
        }
    }
}

struct vinylView: View {
    
    let center: CGPoint
    let radius: CGFloat
    let amplitudes: [Double]
    let angleStep: CGFloat
    let sector: CGFloat
    let sectorCount: CGFloat
    let insideRadius: CGFloat
    
    init(center: CGPoint, radius: CGFloat, insideRadius: CGFloat, amplitudes: [Double], sector: CGFloat, sectorCount: CGFloat) {
        
        self.center = center
        self.radius = radius
        self.amplitudes = amplitudes
        self.angleStep = (.pi * 2) / sectorCount
        self.insideRadius = insideRadius
        self.sectorCount = sectorCount
        self.sector = sector
    }
    var body: some View {
        
        let step = (radius - insideRadius) / CGFloat(self.amplitudes.count)
        
        ForEach(0 ..< self.amplitudes.count) { counter in
            
            Path { path in
                
                let floatCounter = CGFloat(counter)
                path.move(to: CGPoint(x: center.x + ((floatCounter * step + insideRadius) * cos(angleStep * sector)),
                                      y: center.y - ((floatCounter * step + insideRadius) * sin(angleStep * sector))))
                
                path.addLine(to: CGPoint(x: center.x + ((floatCounter * step + insideRadius) * cos(angleStep * (sector + 1.0))),
                                         y: center.y - ((floatCounter * step + insideRadius) * sin(angleStep * (sector + 1.0)))))
                
            }.stroke(lineWidth: 2)
            .fill(Color(UIColor(white: 1 - CGFloat(amplitudes[counter]), alpha: 1.0 )))
            
        }
    }
}
