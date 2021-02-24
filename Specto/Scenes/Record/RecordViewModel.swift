//
//  RecordViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import UIKit

class RecordViewModel: ObservableObject, FFT, Scripter {

    var onSessionComplete: (() -> Void)?

    @Published var amplitudes = [[Double]]()
    @Published var text: String = "Start speaking!"
    @Published var recording = false
    @Published var recordSessionFailed = false

    private var session: RecordingSession?
    private var image = UIImage()

    init(onSessionComplete: (() -> Void)?) {
        self.onSessionComplete = onSessionComplete

        do {
            try session = RecordingSession()
            session?.delegate = self
        } catch {
            recordSessionFailed = true
        }
    }

    func startSession() {
        do {
            try session?.startSession()
        } catch {}
    }

    func stopSession() {
        session?.stopSession(with: image)
    }

    func handoff(amplitudes: [[Double]]) {
        self.amplitudes = amplitudes
    }

    func handoff(text: String) {
        self.text = text
    }

    func setImage(_ image: UIImage) {
        self.image = image
    }
}
