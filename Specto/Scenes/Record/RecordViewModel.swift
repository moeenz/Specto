//
//  RecordViewModel.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import Foundation
import UIKit

class RecordViewModel: ObservableObject, FFT, Scripter {
    
    @Published var amplitudes = [[Double]]()
    @Published var text: String = ""
    @Published var recording = false
    
    private var image = UIImage()
    
    func setImage(_ image: UIImage) {
        self.image = image
    }

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
        session?.stopSession(with: self.image)
    }

    func handoff(amplitudes: [[Double]]) {
        self.amplitudes = amplitudes
    }
    
    func handoff(text: String) {
        self.text = text
    }
}
