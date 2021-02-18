//
//  GalleryView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import SwiftUI

/// This DTO object is unnecessary but Xcode kept showing weird errors when wrapping
///  ForEach view for Recording CoreData objects and since we have little time this approach
///  is taken. Apparently this thread (https://stackoverflow.com/questions/59061270/swiftui-foreach-of-fetchedresults-gives-the-error-value-of-type-nsmanagedob) addresses
///  this issues but there's no time to read! Moving on.
fileprivate struct RecordingDTO: Identifiable {
    var id: ObjectIdentifier
    let keywords: [String]
    let filePath: String
    let createdAt: Int64
}

struct GalleryView: View {

    private var viewModel: GalleryViewModel
    
    private var recordingsList: [RecordingDTO]

    init() {
        viewModel = GalleryViewModel()
        
        recordingsList = viewModel.recordings.map {
            RecordingDTO(id: $0.id,
                         keywords: $0.getKeywords(),
                         filePath: $0.filePath ?? "",
                         createdAt: $0.createdAt)
        }
    }

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(recordingsList) { item in
                    GalleryViewItem(backgroundColor: Color.red, keywords: item.keywords)
                }
            }
        }
    }
}
