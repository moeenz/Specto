//
//  RecordViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import Foundation

class RecordViewModel: ObservableObject, FFT {

    @Published var amplitudes = [[Double]]()

    private var session: RecordingSession?
    
    init() {
        do {
            try session = RecordingSession()
            session?.delegate = self
        } catch {}
    }

    func startSession() {
        do {
            try session?.startSession()
        } catch {}
    }
    
    func stopSession() {
        session?.stopSession()
    }

    func handoff(amplitudes: [[Double]]) {
        self.amplitudes = amplitudes
    }
}
