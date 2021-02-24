//
//  View+extensions.swift
//  Specto
//
//  Created by Moeen Zamani on 2/20/21.
//

import SwiftUI

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }

    func animate(using animation: Animation = Animation.easeInOut(duration: 1),
                 _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }

    func asImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        return controller.view.asImage()
    }
}
