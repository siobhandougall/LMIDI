//
//  LMIDIEndpoint.swift
//  Lapis
//
//  Created by Siobhán Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

public extension MIDIEndpointRef {
    /// A convenience accessor for the endpoint's `kMIDIPropertyDisplayName` property.
    var displayName: String {
        get {
            if let name = LMIDIObject.getStringProperty(name: kMIDIPropertyDisplayName, on: self as MIDIObjectRef) {
                return name
            } else {
                return "[Endpoint \(self)]"
            }
        }
    }
    
    var uniqueID: Int {
        return LMIDIObject.getIntegerProperty(name: kMIDIPropertyUniqueID, on: self)
    }
}
