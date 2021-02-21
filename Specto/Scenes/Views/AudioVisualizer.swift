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
    var animation: Animation {
        Animation.linear(duration: 7.5)
            .repeatForever(autoreverses: false)
    }
    var recording: Bool
    @State private var rotateFactor = Angle(radians: +2 * .pi)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center){
                Circle().foregroundColor(.black).frame(width: geometry.size.width, height: geometry.size.height)
                
                ForEach(0 ..< 33, id: \.self) { number in
                    
                    vinylView(radius: (geometry.size.width / 2 ) - 4,
                              insideRadius: 100,
                              amplitudes: self.amplitudes,
                              circleNumber: CGFloat(number),
                              circleCount: 33)
                }
                
                Image("reflection").resizable().opacity(0.5)
                Image("center")
                    .rotationEffect(recording ? Angle(radians: 0) : Angle(radians: +2 * .pi))
                    .animation(animation)
                
            }.drawingGroup()
        }
    }
}

struct vinylView: View {
    
    let radius: CGFloat
    let amplitudes: [[Double]]
    let circleNumber: CGFloat
    let circleCount: CGFloat
    let insideRadius: CGFloat
    
    
    func t(amplitudes: [[Double]], _ n: Int) -> [Color] {
        
        var v = [Color]()
        for i in 0 ..< amplitudes.count {
            v.append(Color(UIColor(white: CGFloat(amplitudes[i][n]), alpha: 0.6 )))
        }
        
        return v
    }
    
    init(radius: CGFloat, insideRadius: CGFloat, amplitudes: [[Double]], circleNumber: CGFloat, circleCount: CGFloat) {
        
        self.radius = radius
        self.amplitudes = amplitudes
        self.insideRadius = insideRadius
        self.circleCount = circleCount
        self.circleNumber = circleNumber
    }
    

    var body: some View {

        let gradient = AngularGradient(gradient: Gradient(colors:self.t(amplitudes: amplitudes, Int(circleNumber))), center: .center, angle: .zero)

        let size = (insideRadius + (radius - insideRadius) * (circleNumber / circleCount)) * 2
        Circle()
            .stroke(gradient, lineWidth: 1.0)
            .frame(width: size, height: size)
    }
}


