//
//  CBCentralManager+Extension.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 20.02.2023.
//

import CoreBluetooth

extension CBCentralManager: TestableCentralManagerProtocol {
    public func cancelPeripheralConnection(_ peripheral: TestablePeripheralProtocol) {
        guard let peripheral = peripheral as? CBPeripheral else { fatalError() }
        cancelPeripheralConnection(peripheral)
    }
    
    public func connect(_ peripheral: TestablePeripheralProtocol, options: [String : Any]? = nil) {
        guard let peripheral = peripheral as? CBPeripheral else { fatalError() }
        connect(peripheral, options: nil)
    }
}
