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
                
                ForEach(keywords, id: \.self) { keyword in
                Text(keyword)
                }
            }.background(backgroundColor)
        }
    }
}
