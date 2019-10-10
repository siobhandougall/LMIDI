//
//  File.swift
//  
//
//  Created by Sean Dougall on 10/10/19.
//

import Foundation

enum LMIDIError: Error {
    case cannotCreate(code: OSStatus)
    case cannotConnect(code: OSStatus)
}
