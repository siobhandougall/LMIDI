//
//  File.swift
//  
//
//  Created by Sean Dougall on 10/11/19.
//

import Foundation

/// A class that tracks the value of all MIDI controllers across 16 channels.
public class LMIDIControllerState {
    private var values: [[UInt8]]
    public init() {
        self.values = LMIDIControllerState.defaultValues
    }
    
    static let defaultValues: [[UInt8]] = {
        var values = [[UInt8]](repeating: [UInt8](repeating: 0, count: 127), count: 16)
        for channel in 0..<16 {
            values[channel][Int(LMIDIController.expression.rawValue)] = 127
            values[channel][Int(LMIDIController.expressionFine.rawValue)] = 127
            values[channel][Int(LMIDIController.volume.rawValue)] = 100
            values[channel][Int(LMIDIController.pan.rawValue)] = 64
            values[channel][Int(LMIDIController.panFine.rawValue)] = 64
        }
        return values
    }()
    
    /// Set a received value. This happens automatically if attached to a LMIDIInput instance.
    public func setValue(channel: UInt, type: LMIDIController, value: UInt) {
        if type == .allControllersOff {
            self.reset()
            return
        }
        if channel >= 16 || value >= 128 {
            return
        }
        self.values[Int(channel)][Int(type.rawValue)] = UInt8(value)
        if let fineType = type.fineCounterpart {
            self.values[Int(channel)][Int(fineType.rawValue)] = 0
        }
    }
    
    /// Get the raw value of the specified controller. This does not take coarse/fine pairings into account; use `.getExtendedValue(channel:type:)` or `.getNormalizedValue(channel:type:)` to include fine counterparts.
    public func getValue(channel: UInt, type: LMIDIController) -> UInt {
        return UInt(self.values[Int(channel)][Int(type.rawValue)])
    }
    
    /// Pass a coarse controller number to reconstruct the 14-bit value. If the provided controller type does not have a fine counterpart, the plain controller value is left-shifted seven bits and returned with the 7 LSB set to 0.
    public func getExtendedValue(channel: UInt, type: LMIDIController) -> UInt {
        guard let fineType = type.fineCounterpart else {
            return self.getValue(channel: channel, type: type) << 7
        }
        return (self.getValue(channel: channel, type: type) << 7) | self.getValue(channel: channel, type: fineType)
    }
    
    /// Returns the stored value, mapped to the range [0.0, 1.0]. Takes coarse/fine pairings into account, where applicable.
    public func getNormalizedValue(channel: UInt, type: LMIDIController) -> Double {
        if type.fineCounterpart != nil {
            return Double(self.getExtendedValue(channel: channel, type: type)) / 16383.0
        }
        return Double(self.getValue(channel: channel, type: type)) / 127.0
    }
    
    /// Set all values on all channels to their starting defaults. This is also called when `setValue(channel:type:)` receives a message of type `.allControllersOff` (cc 121).
    public func reset() {
        self.values = LMIDIControllerState.defaultValues
    }
}
