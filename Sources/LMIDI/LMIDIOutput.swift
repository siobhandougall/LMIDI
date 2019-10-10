//
//  LMIDIOutput.swift
//  Lapis
//
//  Created by Sean Dougall on 10/8/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

public class LMIDIOutput {
    public let destination: LMIDIDestination
    private var port: MIDIPortRef
    
    public init(destination: LMIDIDestination, portName: String) throws {
        self.destination = destination
        self.port = MIDIPortRef()
        
        let createErr = MIDIOutputPortCreate(self.destination.config.client, portName as CFString, &self.port)
        guard createErr == noErr else {
            throw LMIDIError.cannotCreate(code: createErr)
        }
    }
    
    deinit {
        if self.port != 0 {
            MIDIPortDispose(self.port)
        }
    }

    public func send(_ message: LMIDIMessage) {
        // TODO: Construct a MIDIPacketList from multiple messages to guarantee "simultaneous" delivery.
        // This is either extraordinarily convoluted, or completely impossible, in the Swift interface.
        var packetList = MIDIPacketList(numPackets: 1, packet: (message.asPacket()))
        MIDISend(self.port, self.destination.endpoint, &packetList)
    }
}
