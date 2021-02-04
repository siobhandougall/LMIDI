//
//  File.swift
//  
//
//  Created by Siobhán Dougall on 10/11/19.
//

import Foundation

/// A mapping of standard MIDI controller types. Note: "on/off" controllers typically have values of 127 for on and 0 for off.
public enum LMIDIController: UInt {
    case bankSelect = 0
    case modWheel = 1
    case breath = 2
    case footPedal = 4
    case portamentoTime = 5
    case dataEntry = 6
    case volume = 7
    case balance = 8
    case pan = 10
    case expression = 11
    case effect1 = 12
    case effect2 = 13
    case generalSlider1 = 16
    case generalSlider2 = 17
    case generalSlider3 = 18
    case generalSlider4 = 19
    case bankSelectFine = 32
    case modWheelFine = 33
    case breathFine = 34
    case footPedalFine = 36
    case portamentoTimeFine = 37
    case dataEntryFine = 38
    case volumeFine = 39
    case balanceFine = 40
    case panFine = 42
    case expressionFine = 43
    case effect1Fine = 44
    case effect2Fine = 45
    
    /// Hold pedal (on/off)
    case sustain = 64
    
    /// Portamento (on/off)
    case portamento = 65
    
    /// Sostenuto (on/off)
    case sostenuto = 66
    
    /// Soft pedal (on/off)
    case soft = 67
    
    /// Legato pedal (on/off)
    case legato = 68
    
    /// Hold pedal 2 (on/off)
    case sustain2 = 69
    
    case variation = 70
    case timbre = 71
    case releaseTime = 72
    case attackTime = 73
    case brightness = 74
    case sound6 = 75
    case sound7 = 76
    case sound8 = 77
    case sound9 = 78
    case sound10 = 79
    case generalButton1 = 80
    case generalButton2 = 81
    case generalButton3 = 82
    case generalButton4 = 83
    case effects = 91
    case tremolo = 92
    case chorus = 93
    case celeste = 94
    case phaser = 95
    case dataButtonIncrement = 96
    case dataButtonDecrement = 97
    case nrpnFine = 98
    case nrpnCoarse = 99
    case rpnFine = 100
    case rpnCoarse = 101
    case allSoundOff = 120
    case allControllersOff = 121
    
    /// Controls the local keyboard (on/off).
    case localKeyboard = 122
    
    /// Stops all notes. Data byte unused.
    case allNotesOff = 123
    
    /// Turns off omni mode. Data byte unused.
    case omniModeOff = 124
    
    /// Turns on omni mode. Data byte unused.
    case omniModeOn = 125
    
    /// Enables monophonic operation. Data byte unused.
    case monoOperation = 126
    
    /// Enables polyphonic operation. Data byte unused.
    case polyOperation = 127
    
    /// Shrug emoji
    case unknown = 111
    
    init(number: UInt) {
        if let controller = LMIDIController(rawValue: number) {
            self = controller
        } else {
            self = .unknown
        }
    }
}

extension LMIDIController {
    /// If this controller is a coarse type, returns its corresponding fine controller type, otherwise returns nil.
    public var fineCounterpart: LMIDIController? {
        switch self {
        case .bankSelect: return .bankSelectFine
        case .modWheel: return .modWheelFine
        case .breath: return .breathFine
        case .footPedal: return .footPedalFine
        case .portamentoTime: return .portamentoTimeFine
        case .dataEntry: return .dataEntryFine
        case .volume: return .volumeFine
        case .balance: return .balanceFine
        case .pan: return .panFine
        case .expression: return .expressionFine
        case .effect1: return .effect1Fine
        case .effect2: return .effect2Fine
        case .nrpnCoarse: return .nrpnFine
        case .rpnCoarse: return .rpnFine
        default: return nil
        }
    }

}
