//
//  File.swift
//  
//
//  Created by Siobhán Dougall on 10/10/19.
//

import Foundation

public enum LMIDIError: Error {
    
    /// Core MIDI returned the associated error code when trying to create an object.
    case cannotCreate(code: OSStatus)
    
    /// Core MIDI returned the associated error code when trying to connect a port to an endpoint.
    case cannotConnect(code: OSStatus)
}
