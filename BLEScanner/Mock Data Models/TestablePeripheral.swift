//
//  TestablePeripheral.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 20.02.2023.
//

import Foundation

struct TestablePeripheral: TestablePeripheralProtocol {
    var name: String?
    var identifier: UUID
    
    init(name: String,
         idString: String) {
        self.name = name
        self.identifier = .init(uuidString: idString) ?? .init()
    }
}
