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
    
    var delegate: (FFT & Scripter)?
    
    private let recordingURL: URL
    private let imageURL: URL

    private let carl: Carl
    private let charles: Charles
    
    private let fftHistoryLimit = 75
    private let pcmBuffer = 1024
    private let leakBus = 0
    
    private let keywordsCount = 3
    private let keywordsSeparator = ","
    private var fullTranscriptionText: String = ""
    
    init() throws {
        let urls = RecordingInteractor.generateFileURLs()
        recordingURL = urls.audio
        imageURL = urls.image

        if let audioFile = RecordingSession.createRecordingFile(fileURL: recordingURL) {
            carl = try Carl(limit: fftHistoryLimit,
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
        self.delegate?.handoff(text: text)
    }

    func startSession() throws {

        carl.fftDelegate = delegate
        carl.leakerDelegate = self

        charles.delegate = self

        try carl.start()
        try charles.start()
    }
    
    func stopSession(with image: UIImage) {
        carl.stop()
        charles.stop()
        
        if let data = image.circle().pngData() {
    
            try? data.write(to: imageURL)
        }
        
        Reductio.keywords(from: fullTranscriptionText, count: keywordsCount) { words in
            let context = PersistenceController.init().container.viewContext
            let result = RecordingInteractor(context).create(createdAt: Date().timeMilisUTC,
                                                             keywords: words.joined(separator: keywordsSeparator),
                                                             audioPath: recordingURL.absoluteString,
                                                             imagePath: imageURL.absoluteString,
                                                             text: fullTranscriptionText)
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

