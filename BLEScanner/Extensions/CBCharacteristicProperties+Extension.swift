//
//  CBCharacteristicProperties+Extension.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 19.02.2023.
//

import CoreBluetooth

extension CBCharacteristicProperties {
    var textualRepresentation: String {
        switch self {
        case .broadcast:
            return "Broadcast"
        case .read:
            return "Read"
        case .writeWithoutResponse:
            return "Write without response"
        case .write:
            return "Write"
        case .notify:
            return "Notify"
        case .indicate:
            return "Indicate"
        case .authenticatedSignedWrites:
            return "Authenticated signed writes"
        case .extendedProperties:
            return "Extended properties"
        case .notifyEncryptionRequired:
            return "Notify encryption required"
        case .indicateEncryptionRequired:
            return "Indicate encryption required"
        default:
            return "Unknown characteristic"
        }
    }
}
