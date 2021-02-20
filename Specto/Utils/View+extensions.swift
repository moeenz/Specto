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
}
