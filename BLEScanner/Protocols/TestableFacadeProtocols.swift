//
//  TestableFacadeProtocols.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 20.02.2023.
//

import CoreBluetooth

public protocol TestableCentralManagerProtocol {
    var delegate: CBCentralManagerDelegate? { get set }
    var state: CBManagerState { get }
    
    func connect(_ peripheral: TestablePeripheralProtocol, options: [String : Any]?)
    func cancelPeripheralConnection(_ peripheral: TestablePeripheralProtocol)
    func stopScan()
    func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]?)
}

public protocol TestablePeripheralProtocol {
    var name: String? { get }
    var identifier: UUID { get }
}
