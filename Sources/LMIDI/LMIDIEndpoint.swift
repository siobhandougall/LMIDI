//
//  LMIDIEndpoint.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

public extension MIDIEndpointRef {
    var displayName: String {
        get {
            if let name = LMIDIObject.getStringProperty(name: kMIDIPropertyDisplayName, on: self as MIDIObjectRef) {
                return name
            } else {
                return "[Endpoint \(self)]"
            }
        }
    }
}
