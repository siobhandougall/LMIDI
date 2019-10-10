//
//  LMIDIObject.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

public struct LMIDIObject {
    public static func getIntegerProperty(name: CFString, on object: MIDIObjectRef) -> Int {
        var result = Int32(-1)
        guard MIDIObjectGetIntegerProperty(object, name, &result) == noErr else {
            return -1
        }
        return Int(result)
    }
    
    public static func getStringProperty(name: CFString, on object: MIDIObjectRef) -> String? {
        var result: Unmanaged<CFString>?
        guard MIDIObjectGetStringProperty(object, name, &result) == noErr else {
            return nil
        }
        return result?.takeRetainedValue() as String?
    }
    
    public static func getDataProperty(name: CFString, on object: MIDIObjectRef) -> Data? {
        var result: Unmanaged<CFData>?
        guard MIDIObjectGetDataProperty(object, name, &result) == noErr else {
            return nil
        }
        return result?.takeRetainedValue() as Data?
    }
    
    public static func getDictionaryProperty(name: CFString, on object: MIDIObjectRef) -> [AnyHashable : Any]? {
        var result: Unmanaged<CFDictionary>?
        guard MIDIObjectGetDictionaryProperty(object, name, &result) == noErr else {
            return nil
        }
        return result?.takeRetainedValue() as? [AnyHashable: AnyObject]
    }
}
