//
//  PeripheralData.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 18.02.2023.
//

import CoreBluetooth

struct PeripheralData: Hashable {
    let name: String
    let description: String
    let identifier: String
    
    init(peripheral: CBPeripheral) {
        self.name = peripheral.name ?? "Unknown Name"
        self.description = peripheral.description
        self.identifier = peripheral.identifier.uuidString
    }
    
    init(name: String,
         description: String,
         identifier: String) {
        self.name = name
        self.description = description
        self.identifier = identifier
    }
}
