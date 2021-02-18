//
//  GalleryViewItem.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

struct GalleryViewItem: View {

    var backgroundColor: Color
    var keywords: [String]

    var body: some View {
        ZStack {
            VStack {
                Text(keywords[0])
                Text(keywords[1])
                Text(keywords[2])
            }.background(backgroundColor)
        }
    }
}
