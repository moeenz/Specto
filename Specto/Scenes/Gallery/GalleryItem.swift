//
//  GalleryViewItem.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

/// Tiny view model for GalleryItemView view below.
struct GalleryItem: Identifiable, Equatable {
    let id: Int
    let keywords: [String]
    let image: String?
    let audio: String?
    let coverFont:  Font
    let coverColor: Color

    public static func == (lhs: GalleryItem, rhs: GalleryItem) -> Bool {
        return lhs.id == rhs.id
    }
}
