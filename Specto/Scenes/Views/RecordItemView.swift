//
//  RecordItemView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/20/21.
//

import SwiftUI

/// This view draws the actual cover and disc shape we had in designs for each gallery record item.
struct RecordItemView: View {

    var frameWidth: CGFloat

    var frameHeight: CGFloat
    
    var alignment: Alignment

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray)
                .frame(width: frameWidth, height: frameHeight, alignment: alignment)
                .offset(y: -30)
            Rectangle()
                .fill(Color.red)
                .frame(width: frameWidth, height: frameHeight, alignment: alignment)
        }
    }
}
