//
//  GalleryViewItem.swift
//  Specto
//
//  Created by Moeen Zamani on 2/18/21.
//

import SwiftUI

/// Tiny view model for GalleryItemView view below.
struct GalleryItem: Identifiable {
    let id: Int
    let keywords: [String]
    let image: String?
}
