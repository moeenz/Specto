//
//  Charles.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import Speech
import AVFoundation

enum CharlesError: Error {
    case recognitionInit(String)
}

/// Charles Dickens was a stenagropher unbeknownst to many. This is for you Charles!
class Charles: NSObject, SFSpeechRecognizerDelegate {

    var delegate: Scripter?

    private let speechRecognizer: SFSpeechRecognizer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    private var permissionGranted = false
    private var isRecognitionAvailable = true

    init(langIdentifier: String = "en-US") throws {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: langIdentifier))!
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    }

    private func grantSpeechRecognizerPermission() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            switch authStatus {
            case .authorized:
                self.permissionGranted = true
            default:
                self.permissionGranted = false
            }
        }
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        isRecognitionAvailable = available
    }

    func bufferInput(audioPCMBuffer: AVAudioPCMBuffer) {
        if isRecognitionAvailable {
            recognitionRequest?.append(audioPCMBuffer)
        }
    }

    func start() throws {
        if SFSpeechRecognizer.authorizationStatus() == .notDetermined {
            grantSpeechRecognizerPermission()
        }

        guard let recognitionRequest = recognitionRequest else {
            throw CharlesError.recognitionInit("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false

            if let result = result {
                self?.delegate?.handoff(text: result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self?.stop()
            }
        }
    }

    func stop() {
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask = nil
    }
}
