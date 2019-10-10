//
//  MIDIConfig.swift
//  Lapis
//
//  Created by Sean Dougall on 10/6/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

class LMIDIConfig {
    private static var sharedInstances = [String: LMIDIConfig]()
    var client = MIDIClientRef()
    
    class func shared(name: String) -> LMIDIConfig {
        if LMIDIConfig.sharedInstances[name] == nil {
            LMIDIConfig.sharedInstances[name] = LMIDIConfig(name: name)
        }
        return LMIDIConfig.sharedInstances[name]!
    }
    
    private init(name: String) {
        MIDIClientCreateWithBlock(name as CFString, &self.client) { notePtr in
            let notification = LMIDIConfigNotification(notePtr.pointee)
            NotificationCenter.default.post(Notification(midiConfigNotification: notification))
        }
    }
    
    var inputSources: [LMIDISource] {
        var result = [LMIDISource]()
        let count = MIDIGetNumberOfSources()
        for i in 0..<count {
            let endpoint = MIDIGetSource(i)
            result.append(LMIDISource(endpoint: endpoint, config: self))
        }
        return result
    }
    
    var outputDestinations: [LMIDIDestination] {
        var result = [LMIDIDestination]()
        let count = MIDIGetNumberOfDestinations()
        for i in 0..<count {
            let endpoint = MIDIGetDestination(i)
            result.append(LMIDIDestination(endpoint: endpoint, config: self))
        }
        return result
    }
}
