//
//  View+modifiers.swift
//  Specto
//
//  Created by Moeen Zamani on 2/20/21.
//

import SwiftUI

/// Removes default navigation bar to free it's occupied space.
struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}
