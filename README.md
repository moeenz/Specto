# Specto

Specto is an audio visualizer application using FFT.

**_There are currently minor issues with animations but we're freezing this branch per requested. Check out `main` branch for complete working code and docs. Thanks!_**

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

## SwiftUI Covered APIs

Description on what APIs we have used in SwiftUI on each view. Could be useful.

## License

GNU General Public License v3.0 or later.
See [COPYING](./COPYING) to see the full text.
