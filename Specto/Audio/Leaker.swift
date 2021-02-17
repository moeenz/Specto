//
//  Leaker.swift
//  Specto
//
//  Created by Moeen Zamani on 2/17/21.
//

import AVFoundation

protocol Leaker {
    func handoff(buffer: AVAudioPCMBuffer)
}
