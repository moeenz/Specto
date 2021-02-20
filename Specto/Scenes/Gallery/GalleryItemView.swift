//
//  GalleryViewItem.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

struct GalleryViewItem: View {

    var coverColor: Color

    var keywords: [String]

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: 100, height: 100, alignment: .center)
                .offset(y: -30)
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 100, alignment: .center)
        }
    }
}
