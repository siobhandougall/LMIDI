//
//  LMIDIDestination.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

/// A wrapper for a MIDI endpoint that can serve as a destination for MIDI output. Get a list of these from LMIDIConfig using `config.outputDestinations`.
public struct LMIDIDestination {
    
    /// The raw endpoint ref, for use in Core MIDI APIs.
    public let endpoint: MIDIEndpointRef
    
    /// The configuration instance that instantiated this destination.
    public let config: LMIDIConfig
    
    /// The display name of this destination endpoint.
    public var name: String {
        get {
            return endpoint.displayName
        }
    }
}
