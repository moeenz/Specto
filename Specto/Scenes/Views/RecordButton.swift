//
//  RecordButton.swift
//  Specto
//
//  Created by Moeen Zamani on 2/22/21.
//

import SwiftUI

struct RecordButton: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .fill(Color.red)
                .frame(width: 60, height: 60)
            Circle()
                .foregroundColor(Color.red)
                .frame(width: 50, height: 50)
        }
    }
}
