//
//  StopWatchView.swift
//  Specto
//
//  Created by Moeen Zamani on 2/23/21.
//

import SwiftUI

fileprivate class TimeCounter: ObservableObject {

    @Published var timePassed = 0

    lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
        self?.timePassed += 1
    }

    func startTicking() {
        timer.fire()
    }
}

struct StopWatchView: View {

    var color: Color = .black

    var font: Font = .system(size: 24, weight: .bold, design: .monospaced)

    @StateObject private var ticker = TimeCounter()

    func buildTextComponent(with content: String) -> Text {
        Text(content)
            .foregroundColor(color)
            .font(font)
    }
    
    func buildSecondsString() -> String {
        let minutes = ticker.timePassed % 60
        return minutes < 10 ? "0\(minutes)" : (minutes > 99 ? "99" : "\(minutes)")
    }
    
    func buildMinutesString() -> String {
        let seconds = ticker.timePassed / 60
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }

    var secondsAndMinutes: some View {
        HStack {
            buildTextComponent(with: buildMinutesString())
            buildTextComponent(with: " : ")
            buildTextComponent(with: buildSecondsString())
        }
    }
    
    var body: some View {
        ZStack {
            secondsAndMinutes
                .onAppear {
                    ticker.startTicking()
                }
        }
    }
}
