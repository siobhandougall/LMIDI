//
//  LMIDISource.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

/// A wrapper for a MIDI endpoint that can serve as a source for MIDI input. Get a list of these from LMIDIConfig using `config.inputSources`.
public struct LMIDISource {
    
    /// The raw endpoint ref, for use in Core MIDI APIs.
    public let endpoint: MIDIEndpointRef
    
    /// The configuration instance that instantiated this source.
    public let config: LMIDIConfig
    
    /// The display name of this source endpoint.
    public var name: String {
        get {
            return endpoint.displayName
        }
    }
}
