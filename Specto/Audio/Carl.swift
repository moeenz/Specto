//
//  Carl.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import AudioKit
import AVFoundation

enum CarlError: Error {
    case micNotAvailable(String)
}

/// Carl Friedrich Gauss was the one who originally invented FFT. This is for you Carl!
class Carl {
    
    var fftDelegate: FFT?
    var leakerDelegate: Leaker?

    private let engine = AudioEngine()

    private let mic: AudioEngine.InputNode

    private let micMixer : Mixer
    private let micBooster: Fader
    private let leakMixer: Mixer

    private let recorder: NodeRecorder
    private let sessionFile: AVAudioFile

    private let SAMPLING_RATE: double_t = 44100
    private let FFT_SIZE = 256
    private let pcmBuffer: Int
    private let leakBus: Int
    private var fftTap: FFTTap!

    private let limit: Int
    private var amplitudes = [[Double]]()

    init(limit: Int, pcmBuffer: Int, leakBus: Int, sessionFile: AVAudioFile) throws {
        self.pcmBuffer = pcmBuffer
        self.leakBus = leakBus
        self.limit = limit
        self.sessionFile = sessionFile

        Settings.bufferLength = .medium
        try Settings.setSession(category: .playAndRecord, with: .defaultToSpeaker)

        guard let input = engine.input else {
            throw CarlError.micNotAvailable("Could not access microphone input")
        }

        mic = input
        micMixer = Mixer(mic)
        
        leakMixer = Mixer(micMixer)

        micBooster = Fader(leakMixer)
        micBooster.gain = 0

        recorder = try NodeRecorder(node: mic, file: self.sessionFile)
        engine.output = micBooster

        leakMixer.avAudioNode.installTap(onBus: self.leakBus,
                                          bufferSize: AVAudioFrameCount(self.pcmBuffer),
                                          format: nil) { [unowned self] (buffer, _) in
            self.leakerDelegate?.handoff(buffer: buffer)
        }

        fftTap = FFTTap(micMixer) { [unowned self] fftData in
            self.applyFFT(data: fftData)
            self.fftDelegate?.handoff(amplitudes: self.amplitudes)
        }
    }

    private func scale(n: Double, start1: Double, stop1: Double, start2: Double, stop2: Double) -> Double {
        return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2;
    }

    private func applyFFT(data: [Float]) {
        let temp: [Double] = Array(repeating: 0.5, count: 20)

        amplitudes.append(temp)
        if amplitudes.count > limit {
            amplitudes.removeFirst()
        }

        let index = self.amplitudes.count - 1

        for i in stride(from: 0, to: self.FFT_SIZE - 1, by: 2) {
            let real = data[i]
            let imaginary = data[i + 1]

            let normalizedBinMagnitude = 2.0 * sqrt(real * real + imaginary * imaginary) / Float(self.FFT_SIZE)
            let amplitude = Double(20.0 * log10(normalizedBinMagnitude))

            let scaledAmplitude = (amplitude + 250) / 229.80
            
            if i / 2 < temp.count {
                var mappedAmplitude = self.scale(n: scaledAmplitude, start1: 0.3, stop1: 0.9, start2: 0.0, stop2: 1.0)

                if mappedAmplitude < 0 {
                    mappedAmplitude = 0
                }

                if mappedAmplitude > 1.0 {
                    mappedAmplitude = 1.0
                }

                amplitudes[index][i / 2] = mappedAmplitude
            }
        }
    }

    func start() throws {
        try engine.start()
        try recorder.record()
        fftTap.start()
    }

    func stop() {
        recorder.stop()
        engine.stop()
    }
}
