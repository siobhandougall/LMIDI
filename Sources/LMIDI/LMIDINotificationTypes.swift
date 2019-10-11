//
//  MIDINotificationTypes.swift
//  Lapis
//
//  Created by Sean Dougall on 10/7/19.
//  Copyright © 2019 Lapis. All rights reserved.
//

import Foundation
import CoreMIDI

/// Notifications of MIDI setup changes.
public enum LMIDIConfigNotification: String {
    case setupChanged = "LMIDIConfigSetupChangedNotification"
    case objectAdded = "LMIDIConfigObjectAddedNotification"
    case objectRemoved = "LMIDIConfigObjectRemovedNotification"
    case propertyChanged = "LMIDIConfigPropertyChangedNotification"
    case thruConnectionsChanged = "LMIDIConfigThruConnectionsChangedNotification"
    case serialPortOwnerChanged = "LMIDIConfigSerialPortOwnerChangedNotification"
    case ioError = "LMIDIConfigIOErrorNotification"
    case unknown = "LMIDIConfigUnknownNotification"
    
    init(_ rawNotification: MIDINotification) {
        switch rawNotification.messageID {
        case .msgSetupChanged:
            self = .setupChanged
        case .msgObjectAdded:
            self = .objectAdded
        case .msgObjectRemoved:
            self = .objectRemoved
        case .msgPropertyChanged:
            self = .propertyChanged
        case .msgThruConnectionsChanged:
            self = .thruConnectionsChanged
        case .msgSerialPortOwnerChanged:
            self = .serialPortOwnerChanged
        case .msgIOError:
            self = .ioError
        default:
            self = .unknown
        }
    }
}

extension Notification {
    init(midiConfigNotification: LMIDIConfigNotification) {
        var userInfo = [AnyHashable : Any]()
        switch midiConfigNotification {
            // TODO: Populate userInfo depending on notification type
        default: break
        }
        self.init(name: Notification.Name(midiConfigNotification.rawValue), object: nil, userInfo: userInfo)
    }
}
