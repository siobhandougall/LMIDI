//
//  MIDIInput.swift
//  Lapis
//
//  Created by Sean Dougall on 10/6/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

class LMIDIInput {
    let source: LMIDISource
    private let portName: String
    private var port: MIDIPortRef
    private var listenBlock: ([LMIDIMessage]) -> ()
    init(source: LMIDISource, portName: String) throws {
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
    
    func listen(_ block: @escaping ([LMIDIMessage]) -> ()) throws {
        self.listenBlock = block
        
        let connectErr = MIDIPortConnectSource(self.port, self.source.endpoint, nil)
        guard connectErr == noErr else {
            throw LMIDIError.cannotConnect(code: connectErr)
        }
    }
    
    func stop() {
        self.listenBlock = { messages in }
        if self.port != 0 {
            MIDIPortDisconnectSource(self.port, self.source.endpoint)
        }
    }
}
