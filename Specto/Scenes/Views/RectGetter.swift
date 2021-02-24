//
//  RectGetter.swift
//  Specto
//
//  Created by Moeen Zamani on 2/24/21.
//

import SwiftUI

struct RectGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { proxy in
            createView(proxy: proxy)
        }
    }

    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            rect = proxy.frame(in: .global)
        }

        return Rectangle().fill(Color.clear)
    }
}
