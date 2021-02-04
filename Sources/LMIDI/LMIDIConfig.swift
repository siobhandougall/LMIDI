//
//  MIDIConfig.swift
//  Lapis
//
//  Created by Siobhán Dougall on 10/6/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

/// The centralized configuration controller for one MIDI client instance. Generally one LMIDIConfig object should be instantiated per context (e.g. per open document).
public class LMIDIConfig {
    var client = MIDIClientRef()
    
    /// Creates a new config instance. This manages ports and connections, so be sure to retain this reference.
    public init(name: String) {
        MIDIClientCreateWithBlock(name as CFString, &self.client) { notePtr in
            let notification = LMIDIConfigNotification(notePtr.pointee)
            NotificationCenter.default.post(Notification(midiConfigNotification: notification))
        }
    }
    
    /// A list of all currently available MIDI sources.
    public var inputSources: [LMIDISource] {
        var result = [LMIDISource]()
        let count = MIDIGetNumberOfSources()
        for i in 0..<count {
            let endpoint = MIDIGetSource(i)
            result.append(LMIDISource(endpoint: endpoint, config: self))
        }
        return result
    }
    
    /// A list of all currently available MIDI destinations.
    public var outputDestinations: [LMIDIDestination] {
        var result = [LMIDIDestination]()
        let count = MIDIGetNumberOfDestinations()
        for i in 0..<count {
            let endpoint = MIDIGetDestination(i)
            result.append(LMIDIDestination(endpoint: endpoint, config: self))
        }
        return result
    }
}
