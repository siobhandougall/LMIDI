//
//  MIDIPacket.swift
//  Lapis
//
//  Created by Sean Dougall on 10/6/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

// Reference for `withUnsafeBytes(of:)`: https://oleb.net/blog/2017/12/swift-imports-fixed-size-c-arrays-as-tuples/

import Foundation
import CoreMIDI

typealias LMIDIByteTuple256 = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)

/// A single MIDI message and its associated data.
public enum LMIDIMessage {
    /// An unknown MIDI message type.
    /// - `dataByteValue`: Contains the offending data byte, for reference.
    case unknown(dataByteValue: UInt)
    
    /// A note-on message.
    /// - `channel`: ranges from 0-15.
    /// - `note`: MIDI note number.
    /// - `velocity`: attack velocity. As with all MIDI considerations, a note-on with a velocity of 0 must be interpreted as a note-off.
    case noteOn(channel: UInt, note: UInt, velocity: UInt)
    
    /// A note-off message.
    /// - `channel`: ranges from 0-15.
    /// - `note`: MIDI note number.
    /// - `velocity`: release velocity.
    case noteOff(channel: UInt, note: UInt, velocity: UInt)
    
    /// An aftertouch pressure message.
    /// - `channel`: ranges from 0-15.
    /// - `note`: MIDI note number.
    /// - `pressure`: aftertouch pressure value.
    case aftertouch(channel: UInt, note: UInt, pressure: UInt)
        
    /// A MIDI controller (cc) message.
    /// - `channel`: ranges from 0-15.
    /// - `number`: MIDI controller number.
    /// - `value`: the value of this controller message.
    /// Note: NRPN messages are treated as separate controller changes. Reconstructing them is left to the caller.
    case controller(channel: UInt, number: UInt, value: UInt)
    
    /// A program change message.
    /// - `channel`: ranges from 0-15.
    /// - `number`: program number.
    case programChange(channel: UInt, number: UInt)
    
    /// A channel pressure message.
    /// - `channel`: ranges from 0-15.
    /// - `pressure`: channel pressure value.
    case channelPressure(channel: UInt, pressure: UInt)
    
    /// A pitch wheel message.
    /// - `channel`: ranges from 0-15.
    /// - `value`: ranges from -8192 to 8191. Call `.normalizedPitchValue` to extract the value as a Double in the range [-1.0, 1.0).
    case pitchWheel(channel: UInt, value: UInt)
    
    /// A system exclusive (SysEx) message.
    /// - `bytes`: the message data. Does not include the opening `F0` or closing `F7` bytes that delineate all SysEx messages.
    case sysEx(bytes: [UInt8])
    
    /// A MIDI Time Code quarter frame message.
    /// - `value`: the raw value of the data byte. Parsing is left up to the caller.
    case mtcQuarterFrame(value: UInt)
    
    /// A Song Position Pointer message
    /// - `midiBeat`: the MIDI beat (i.e. 16th note) parsed from the two data bytes.
    case songPositionPointer(midiBeat: UInt)
    
    /// A Song Select message.
    /// - `number`: The song number being selected.
    case songSelect(number: UInt)
    
    /// A Tune Request message.
    case tuneRequest
    
    /// A MIDI Clock message. Indicates passage of 1/24 of a quarter note.
    case clock
    
    /// A MIDI Tick message. Indicates passage of 10 milliseconds on the sender's clock.
    case tick
    
    /// A MIDI Start message. Starts the selected sequence from beat 0.
    case start
    
    /// A MIDI Continue message. Starts the selected sequence from the current time.
    case `continue`
    
    /// A MIDI Stop message.
    case stop
    
    /// An Active Sense message. Senders may send a message every 300 ms to ping the connection.
    case activeSense
    
    /// A Reset message.
    case reset
    
    static func fromRawPacket(_ packet: MIDIPacket) -> [LMIDIMessage] {
        var d = packet.data
        var bytes = [UInt8](UnsafeBufferPointer(start: &d.0, count: 256))
       
        var result = [LMIDIMessage]()
        var remainingBytes = Int(packet.length)
        while remainingBytes > 0 {
            let msg = parse(rawPacketData: bytes), bytesRead = msg.byteCount
            result.append(msg)
            bytes.removeSubrange(0..<bytesRead)
            remainingBytes -= bytesRead
        }
        return result
    }
    
    private static func parse(rawPacketData data: [UInt8]) -> LMIDIMessage {
        let channelNibble = UInt(data[0] & 0x0f)
        switch data[0] {
        case 0x80...0x8f:
            return .noteOff(channel: channelNibble, note: UInt(data[1]), velocity: UInt(data[2]))
        case 0x90...0x9f:
            return .noteOn(channel: channelNibble, note: UInt(data[1]), velocity: UInt(data[2]))
        case 0xa0...0xaf:
            return .aftertouch(channel: channelNibble, note: UInt(data[1]), pressure: UInt(data[2]))
        case 0xb0...0xbf:
            return .controller(channel: channelNibble, number: UInt(data[1]), value: UInt(data[2]))
        case 0xc0...0xcf:
            return .programChange(channel: channelNibble, number: UInt(data[1]))
        case 0xd0...0xdf:
            return .channelPressure(channel: channelNibble, pressure: UInt(data[1]))
        case 0xe0...0xef:
            return .pitchWheel(channel: channelNibble, value: (UInt(data[2]) << 7) | UInt(data[1]))
        case 0xf0:
            return .sysEx(bytes: parseSysExData(rawPacketData: data))
        case 0xf1:
            return .mtcQuarterFrame(value: UInt(data[1]))
        case 0xf2:
            return .songPositionPointer(midiBeat: UInt((data[2] << 7) | data[1]))
        case 0xf3:
            return .songSelect(number: UInt(data[1]))
        case 0xf6:
            return .tuneRequest
        case 0xf8:
            return .clock
        case 0xf9:
            return .tick
        case 0xfa:
            return .start
        case 0xfb:
            return .continue
        case 0xfc:
            return .stop
        case 0xfe:
            return .activeSense
        case 0xff:
            return .reset
        default:
            return .unknown(dataByteValue: UInt(data[0]))
        }
    }
    
    private static func parseSysExData(rawPacketData data: [UInt8]) -> [UInt8] {
        var bytes = [UInt8]()
        for i in 1..<data.count {
            let c = data[i]
            if c == 0xf7 {
                break
            }
            bytes.append(c)
        }
        return bytes
    }
    
    private var byteCount: Int {
        get {
            switch self {
            case .noteOn: return 3
            case .noteOff: return 3
            case .aftertouch: return 3
            case .controller: return 3
            case .programChange: return 2
            case .channelPressure: return 2
            case .pitchWheel: return 3
            case .sysEx(let bytes): return bytes.count + 2
            case .mtcQuarterFrame: return 2
            case .songPositionPointer: return 3
            case .songSelect: return 2
            default: return 1
            }
        }
    }
    
    /// Maps the associated pitch wheel value to a Double in a range of [-1.0, 1.0). Applies to pitch wheel events only.
    public var normalizedPitchValue: Double {
        guard case .pitchWheel(_, let value) = self else {
            return 0.0
        }
        return (Double(value) - Double(0x2000)) / Double(0x2000)
    }
    
    /// Constructs a Core MIDI packet struct from this message, with a timestamp of 0 (i.e. immediate).
    public func asPacket() -> MIDIPacket {
        return self.asPacket(timeStamp: 0)
    }
    
    /// Constructs a Core MIDI packet struct from this message, with the given timestamp.
    public func asPacket(timeStamp: MIDITimeStamp) -> MIDIPacket {
        var bytes = [UInt8](repeating: 0, count: 256)
        switch self {
        case .noteOn(let channel, let note, let velocity):
            bytes[0] = UInt8(channel | 0x90)
            bytes[1] = UInt8(note)
            bytes[2] = UInt8(velocity)
        case .noteOff(let channel, let note, let velocity):
            bytes[0] = UInt8(channel | 0x80)
            bytes[1] = UInt8(note)
            bytes[2] = UInt8(velocity)
        case .aftertouch(let channel, let note, let pressure):
            bytes[0] = UInt8(channel | 0xa0)
            bytes[1] = UInt8(note)
            bytes[2] = UInt8(pressure)
        case .controller(let channel, let number, let value):
            bytes[0] = UInt8(channel | 0xb0)
            bytes[1] = UInt8(number)
            bytes[2] = UInt8(value)
        case .programChange(let channel, let number):
            bytes[0] = UInt8(channel | 0xb0)
            bytes[1] = UInt8(number)
        case .channelPressure(let channel, let pressure):
            bytes[0] = UInt8(channel | 0xb0)
            bytes[1] = UInt8(pressure)
        case .pitchWheel(let channel, let value):
            bytes[0] = UInt8(channel | 0xb0)
            bytes[1] = UInt8(value & 0x7f)
            bytes[2] = UInt8(value >> 7)
        case .sysEx(let sysExBytes):
            bytes[0] = 0xf0
            bytes.replaceSubrange(1...sysExBytes.count, with: sysExBytes)
            bytes[sysExBytes.count + 1] = 0xf7
        case .mtcQuarterFrame(let value):
            bytes[0] = 0xf1
            bytes[1] = UInt8(value)
        case .songPositionPointer(let midiBeat):
            bytes[0] = 0xf2
            bytes[1] = UInt8(midiBeat & 0x7f)
            bytes[2] = UInt8(midiBeat >> 7)
        case .songSelect(let number):
            bytes[0] = 0xf3
            bytes[1] = UInt8(number)
        case .tuneRequest:
            bytes[0] = 0xf6
        case .clock:
            bytes[0] = 0xf8
        case .tick:
            bytes[0] = 0xf9
        case .start:
            bytes[0] = 0xfa
        case .continue:
            bytes[0] = 0xfb
        case .stop:
            bytes[0] = 0xfc
        case .activeSense:
            bytes[0] = 0xfe
        case .reset:
            bytes[0] = 0xff
        default:
            break
        }
        
        let data = withUnsafeBytes(of: &bytes[0]) { (rawPtr) -> LMIDIByteTuple256 in
            let ptr = rawPtr.baseAddress!.assumingMemoryBound(to: LMIDIByteTuple256.self)
            return ptr.pointee
        }
        
        return MIDIPacket(timeStamp: timeStamp, length: UInt16(self.byteCount), data: data)
    }
}
