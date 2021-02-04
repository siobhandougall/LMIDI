//
//  LMIDIOutput.swift
//  Lapis
//
//  Created by Siobhán Dougall on 10/8/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

/// An object that manages input from a single source.
public class LMIDIOutput {
    
    /// The MIDI destination to which this output will send messages.
    public let destination: LMIDIDestination
    private var port: MIDIPortRef
    
    /// Instantiate an output using the given port name, to be attached to the given destination. Call `send(_:)` or `send(_:at:)` to send MIDI to this output.
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

    /// Send the given message immediately (i.e. with a Core MIDI timestamp of 0).
    public func send(_ message: LMIDIMessage) {
        self.send(message, at: 0)
    }
    
    /// Send the given message with a specified timestamp.
    public func send(_ message: LMIDIMessage, at timeStamp: MIDITimeStamp) {
        // TODO: Construct a MIDIPacketList from multiple messages to guarantee "simultaneous" delivery.
        // This is either extraordinarily convoluted, or completely impossible, in the Swift interface.
        var packetList = MIDIPacketList(numPackets: 1, packet: (message.asPacket(timeStamp: timeStamp)))
        MIDISend(self.port, self.destination.endpoint, &packetList)
    }
}
