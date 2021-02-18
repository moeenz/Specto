//
//  RecordingSession.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import AVFoundation
import Reductio
import AudioKit

enum RecordingSessionError: Error {
    case audioFile(String)
    case recordPersist(String)
}

class RecordingSession: Scripter, Leaker {
    
    var delegate: FFT?
    
    private let recordingURL: URL

    private let carl: Carl
    private let charles: Charles
    
    private let fftLimit = 50
    private let pcmBuffer = 1024
    private let leakBus = 0
    
    private let keywordsCount = 3
    private let keywordsSeparator = ","
    private var fullTranscriptionText: String = ""
    
    init() throws {
        recordingURL = RecordingInteractor.generateFileURL()

        if let audioFile = RecordingSession.createRecordingFile(fileURL: recordingURL) {
            carl = try Carl(limit: fftLimit,
                        pcmBuffer: pcmBuffer,
                        leakBus: leakBus,
                        sessionFile: audioFile)
        } else {
            throw RecordingSessionError.audioFile("Could not created recording audio file")
        }
        charles = try Charles(langIdentifier: "en-US")
    }
    
    func handoff(buffer: AVAudioPCMBuffer) {
        charles.bufferInput(audioPCMBuffer: buffer)
    }

    func handoff(text: String) {
        fullTranscriptionText = text
    }

    func startSession() throws {

        carl.fftDelegate = delegate
        carl.leakerDelegate = self

        charles.delegate = self

        try carl.start()
        try charles.start()
    }
    
    func stopSession() {
        carl.stop()
        charles.stop()
        
        Reductio.keywords(from: fullTranscriptionText, count: keywordsCount) { words in
            let context = PersistenceController.init().container.viewContext
            let result = RecordingInteractor(context).create(createdAt: Date().timeMilisUTC,
                                                             keywords: words.joined(separator: keywordsSeparator),
                                                             filePath: recordingURL.absoluteString)
            if !result {
                print("Could not save session with path: \(recordingURL.absoluteString)")
            }
        }
    }

    private static func createRecordingFile(fileURL: URL) -> AVAudioFile? {
        var settings = Settings.audioFormat.settings
        settings[AVLinearPCMIsNonInterleaved] = NSNumber(value: false)

        guard let audioFile = try? AVAudioFile(forWriting: fileURL,
                                               settings: settings,
                                               commonFormat: Settings.audioFormat.commonFormat,
                                               interleaved: true) else { return nil }

        return audioFile
    }
}

