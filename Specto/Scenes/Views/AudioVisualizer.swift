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
    let center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    var body: some View {

        ZStack{
   
            ForEach(0 ..< self.amplitudes.count, id: \.self) { number in
            
                vinylView(center: center,
                          radius: 80,
                          insideRadius: 50,
                          amplitudes: self.amplitudes[number],
                          sector: CGFloat(number),
                          sectorCount: 50.0)
            }
            
        }.drawingGroup()
    }
}

struct vinylView: View {
    
    let center: CGPoint
    //let count: CGFloat
    let radius: CGFloat
    let amplitudes: [Double]
    let angleStep: CGFloat
    let sector: CGFloat
    let sectorCount: CGFloat
    let insideRadius: CGFloat
    
    init(center: CGPoint, radius: CGFloat, insideRadius: CGFloat, amplitudes: [Double], sector: CGFloat, sectorCount: CGFloat) {
        
        //self.count = CGFloat(count)
        self.center = center
        self.radius = radius
        self.amplitudes = amplitudes
        self.angleStep = (.pi * 2) / sectorCount
        self.insideRadius = insideRadius
        self.sectorCount = sectorCount
        self.sector = sector
    }
    var body: some View {
    
        let step = radius / CGFloat(self.amplitudes.count)

        ForEach(0 ..< self.amplitudes.count) { counter in
            
            Path { path in

                let floatCounter = CGFloat(counter)
                path.move(to: CGPoint(x: center.x + ((floatCounter * step + insideRadius) * cos(angleStep * sector)),
                                      y: center.y - ((floatCounter * step + insideRadius) * sin(angleStep * sector))))
                
                path.addLine(to: CGPoint(x: center.x + ((floatCounter * step + insideRadius) * cos(angleStep * (sector + 1.0))),
                                         y: center.y - ((floatCounter * step + insideRadius) * sin(angleStep * (sector + 1.0)))))

            }.stroke(lineWidth: 1)
            .fill(Color(UIColor(white: CGFloat(amplitudes[counter]), alpha: 1.0 )))
            
        }
    }
}
