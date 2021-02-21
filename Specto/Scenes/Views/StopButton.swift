//
//  StopButton.swift
//  Specto
//
//  Created by Moeen Zamani on 2/22/21.
//

import SwiftUI

struct StopButton: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .fill(Color.white)
                .frame(width: 60, height: 60)
            
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color.white)
                .frame(width: 20,
                       height:20)
        }
    }
}
