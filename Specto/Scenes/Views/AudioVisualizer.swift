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
    @State var degree: Double = 0
    
    var animation: Animation {
        Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
    }
    
    @State private var rotateFactor = Angle(radians: 0)

    
    var body: some View {
       GeometryReader { geometry in
            ZStack{
                Circle().foregroundColor(.black).frame(width: geometry.size.width, height: geometry.size.height)
                ForEach(0 ..< self.amplitudes.count, id: \.self) { number in

                vinylView(center: CGPoint(x: geometry.size.width / 2, y:geometry.size.height / 2),
                              radius: geometry.size.width / 2,
                              insideRadius: geometry.size.width / 6,
                              amplitudes: self.amplitudes[number],
                              sector: CGFloat(number),
                              sectorCount: 50.0)
                }
                
                Image("adaptor")
                    .rotationEffect(rotateFactor)
                    .onAppear {
                        withAnimation(animation) {
                            rotateFactor = Angle(radians: 3 * Double.pi)
                        }
                    }
                
            }.drawingGroup()
        }.frame(width: 350, height: 350)
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
                
            }.stroke(lineWidth: 0.7)
            .fill(Color(UIColor(white: 1 - CGFloat(amplitudes[counter]), alpha: 1.0 )))
            
        }
    }
}
