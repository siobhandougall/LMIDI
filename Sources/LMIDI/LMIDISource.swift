//
//  LMIDISource.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

struct LMIDISource {
    let endpoint: MIDIEndpointRef
    let config: LMIDIConfig
    var name: String {
        get {
            return endpoint.displayName
        }
    }
}
