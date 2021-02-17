# Specto

Specto is an audio visualizer application using FFT.

## Setup

This project uses both Cocoapods and Swift package manager to dependency issues. Install Cocoapods dependencies using:

```bash
    pod install
```

## Recorder

Each session is processed by Speech API to detect verbal context. There's a `RecordingSession` object which handles both recording and Speech-to-Text capabilities. It also outputs FFT amplitudes to be visualized by some view.

```swift
    do {
        try session = RecordingSession()
        try session.startSession()
    } catch {}
```

It's necessary to call `RecordingSession.stopSession()` to persist the session.

```swift
    session.stopSession()
```

This method persists audio file and the processed context using CoreData model objects.
