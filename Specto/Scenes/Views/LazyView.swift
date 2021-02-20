//
//  LazyView.swift
//  Specto
//
//  Created by Abbas Mousavi on 2/18/21.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

