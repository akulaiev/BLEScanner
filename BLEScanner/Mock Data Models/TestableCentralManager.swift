//
//  TestableCentralManager.swift
//  BLEScannerTests
//
//  Created by Anna Koulaeva on 20.02.2023.
//

import CoreBluetooth

class TestableCentralManager: NSObject, TestableCentralManagerProtocol {
    var delegate: CBCentralManagerDelegate?
    var state: CBManagerState
    
    func connect(_ peripheral: TestablePeripheralProtocol, options: [String : Any]?) {
        print("Connect called")
    }
    
    func cancelPeripheralConnection(_ peripheral: TestablePeripheralProtocol) {
        print("Cancelled")
    }
    
    func stopScan() {
        print("Stopped")
    }
    
    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?) {
        print("Scanned")
    }
    
    init(state: CBManagerState) {
        self.state = state
    }
}

extension TestableCentralManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState")
    }
}
