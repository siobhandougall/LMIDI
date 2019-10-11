//
//  LMIDIObject.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

/// A set of convenience methods for accessing properties on MIDIObjectRef instances. These methods are all static; there is no need to instantiate this struct.
public struct LMIDIObject {
    
    /// Get the specified integer property, returning `-1` if an error occurs.
    public static func getIntegerProperty(name: CFString, on object: MIDIObjectRef) -> Int {
        var result = Int32(-1)
        guard MIDIObjectGetIntegerProperty(object, name, &result) == noErr else {
            return -1
        }
        return Int(result)
    }
    
    /// Get the specified string property, returning `nil` if an error occurs.
    public static func getStringProperty(name: CFString, on object: MIDIObjectRef) -> String? {
        var result: Unmanaged<CFString>?
        guard MIDIObjectGetStringProperty(object, name, &result) == noErr else {
            return nil
        }
        return result?.takeRetainedValue() as String?
    }
    
    /// Get the specified data property, returning `nil` if an error occurs.
    public static func getDataProperty(name: CFString, on object: MIDIObjectRef) -> Data? {
        var result: Unmanaged<CFData>?
        guard MIDIObjectGetDataProperty(object, name, &result) == noErr else {
            return nil
        }
        return result?.takeRetainedValue() as Data?
    }
    
    /// Get the specified dictionary property, returning `nil` if an error occurs.
    public static func getDictionaryProperty(name: CFString, on object: MIDIObjectRef) -> [AnyHashable : Any]? {
        var result: Unmanaged<CFDictionary>?
        guard MIDIObjectGetDictionaryProperty(object, name, &result) == noErr else {
            return nil
        }
        return result?.takeRetainedValue() as? [AnyHashable: AnyObject]
    }
}
