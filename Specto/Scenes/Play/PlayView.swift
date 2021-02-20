//
//  PlayView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

struct PlayView: View {
    
    var navDismissHandler: NavDismissHandler?

    /// We use this Environment field to modify presentation status.
    @Environment(\.presentationMode) var presentation

    /// This state changes so we can have the growth animation.
    @State private var scaleFactor = CGSize(width: 1, height: 1)
    /// This state changes so we cann have the rotation animation.
    @State private var rotateFactor = Angle(radians: 0)

    /// Animate scaling the object to this size.
    private let targetScale = CGSize(width: 2, height: 2)
    /// Animate rotating the object to this angle.
    private let targetRotation = Angle(radians: 2 * Double.pi)

    // Configuration values for animations.
    private let animationLength: Double = 0.75
    private let animation: Animation = .linear(duration: 0.5)

    init(navDismissHandler: NavDismissHandler? = nil) {
        self.navDismissHandler = navDismissHandler
    }

    var body: some View {
        ZStack {
            RecordItemView(frameWidth: 100, frameHeight: 100, alignment: .center)
                .scaleEffect(scaleFactor)
                .rotationEffect(rotateFactor)
                .onAppear {
                    withAnimation(animation) {
                        scaleFactor = targetScale
                        rotateFactor = targetRotation
                    }
                }
            VStack {
                Spacer()
                // TODO: This should change. Not completely implemented.
                Button("Back to Gallery") {
                    withAnimation(.linear(duration: 1)) {
                        scaleFactor =  CGSize(width: 1, height: 1)
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                        navDismissHandler?()
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        }.hiddenNavigationBarStyle()
    }
}
