//
//  AudioRecorder.swift
//  FAITH
//
//  Created by Guylian Bollon on 28/03/2021.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: ObservableObject {
    @Published var isPlaying = false
    var audioRecorder: AVAudioRecorder!
    @Published var recording : Recording
    var audioPlayer : AVAudioPlayer!
    init(){
        recording = Recording(fileURL: nil, createdAt: nil)
    }
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("\(Date().toString(dateFormat: "dd-MM-YY_'at'_HH:mm:ss")).m4a")
            let settings = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            recording = Recording(fileURL: audioFilename, createdAt: getCreationDate(for: audioFilename))
            audioRecorder.record()
        } catch {
            print("Failed to set up recording session")
        }
    }
    func stopRecording(){
        audioRecorder.stop()
    }
    func pauseRecording(){
        audioRecorder.pause()
    }
    func unpauseRecording(){
        audioRecorder.record()
    }
    func getCreationDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func startPlayback(){
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: recording.fileURL!)
                audioPlayer.play()
                isPlaying = true
            } catch {
                print("Playback failed.")
            }
        } catch {
            print("Playing over the device's speakers failed")
        }
    }
    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }
    func removeRecording(){
        do {
            try FileManager.default.removeItem(at: recording.fileURL!)
            isPlaying = false
        } catch {
            print("File could not be deleted!")
        }
    }
}
extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
