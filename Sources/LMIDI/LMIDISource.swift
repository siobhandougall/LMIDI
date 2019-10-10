//
//  LMIDISource.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

public struct LMIDISource {
    public let endpoint: MIDIEndpointRef
    public let config: LMIDIConfig
    public var name: String {
        get {
            return endpoint.displayName
        }
    }
}
