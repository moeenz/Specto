//
//  RecordItemView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/20/21.
//

import SwiftUI
import Kingfisher

/// This view draws the actual cover and disc shape we had in designs for each gallery record item.
struct RecordItemView: View {

    var item: GalleryItem
    var frameWidth: CGFloat

    var frameHeight: CGFloat
    
    var alignment: Alignment

    var body: some View {
        ZStack {

            if let image = item.image {
            KFImage(RecordingInteractor.getDocumentsDirectory().appendingPathComponent(image))
                .resizable()
                 .frame(width: frameWidth, height: frameHeight, alignment: alignment)
                .offset(y: -35)
            }
            Rectangle()
                .fill(Color.green)
                .frame(width: frameWidth, height: frameHeight - 35, alignment: alignment)
            
            VStack(alignment: .leading) {
            ForEach(item.keywords, id: \.self) { keyword in
                
                Text(keyword.uppercased()).font(.system(size: 17, weight: .bold, design: .serif))
            }
            }.offset(x: -10)
        }
    }
}
