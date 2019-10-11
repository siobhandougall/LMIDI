//
//  MIDIInput.swift
//  Lapis
//
//  Created by Sean Dougall on 10/6/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

/// An object that manages input from a single source.
public class LMIDIInput {
    
    /// The MIDI source to which this input will connect when listening.
    public let source: LMIDISource
    
    private let portName: String
    private var port: MIDIPortRef
    private var listenBlock: ([LMIDIMessage]) -> ()
    
    /// Instantiate an input using the given port name, to be attached to the given source. Does not automatically start listening. Call `listen(_:)` and `stop()` to start and stop.
    public init(source: LMIDISource, portName: String) throws {
        self.source = source
        self.portName = portName
        self.port = MIDIPortRef()
        listenBlock = { packets in }
        
        weak var weakSelf = self
        let createErr = MIDIInputPortCreateWithBlock(self.source.config.client, self.portName as CFString, &self.port, { packetListPtr, refCon in
            var packetList = packetListPtr.pointee
            var messages = [LMIDIMessage]()
            var packet = UnsafeMutablePointer(&packetList.packet)
            for _ in 0..<packetList.numPackets {
                let newMessages = LMIDIMessage.fromRawPacket(packet.pointee)
                messages.append(contentsOf: newMessages)
                packet = MIDIPacketNext(packet)
            }
            weakSelf?.listenBlock(messages)
        })
        
        guard createErr == noErr else {
            throw LMIDIError.cannotCreate(code: createErr)
        }
    }
    
    deinit {
        if self.port != 0 {
            self.stop()
            MIDIPortDispose(self.port)
        }
    }
    
    /// Begin listening to input, calling the provided block for each group of messages received.
    public func listen(_ block: @escaping ([LMIDIMessage]) -> ()) throws {
        self.listenBlock = block
        
        let connectErr = MIDIPortConnectSource(self.port, self.source.endpoint, nil)
        guard connectErr == noErr else {
            throw LMIDIError.cannotConnect(code: connectErr)
        }
    }
    
    /// Stop listening. This disconnects the underlying MIDI port, but does not dispose of it.
    public func stop() {
        self.listenBlock = { messages in }
        if self.port != 0 {
            MIDIPortDisconnectSource(self.port, self.source.endpoint)
        }
    }
}
