//
//  DevicesListView+ViewModel.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 17.02.2023.
//

import SwiftUI
import CoreBluetooth

extension DevicesListView {
   final class ViewModel: NSObject, ObservableObject {
       //MARK: ViewModel properties
       @Published var shoudShowBLEProblemAlert = false
       @Published var connectionError: ConnectionError?
       @Published var peripheralsDisplayData: [PeripheralData] = []
       @Published var isScanningForDevices = false
       @Published var isConnectingToDeviceWithId: String?
       @Published var connectedDeviceInfo: DeviceInfo?
       @Published var shouldShowDeviceInfoView = false
       @Published var deviceDisconnected = false
        
       private var centralManager: TestableCentralManagerProtocol!
       private var discoveredPeripherals: [TestablePeripheralProtocol] = []
        
       override init() {
           super.init()
           self.centralManager = CBCentralManager(delegate: self, queue: .main)
       }
       
       //Init for testing purpose
       init(managerState: CBManagerState = .poweredOn,
            discoveredPeripherals: [TestablePeripheral] = []) {
           super.init()
           self.centralManager = TestableCentralManager.init(state: managerState)
           self.discoveredPeripherals = discoveredPeripherals
       }
        
        //MARK: ViewModel methods
        func scanConnections() {
            guard centralManager.state == .poweredOn, !isScanningForDevices else { return }
            isScanningForDevices = true
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        }
        
        func stopScanningForConnections() {
            centralManager.stopScan()
            isScanningForDevices = false
        }
        
        func connectTo(deviceId: String) {
            stopScanningForConnections()
            
            guard let peripheral = getPeripheral(with: deviceId) else {
                showConnectionError(with: "Couldn't find the device")
                return
            }

            isConnectingToDeviceWithId = deviceId
            centralManager.connect(peripheral, options: nil)
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] timer in
                if self?.shouldShowDeviceInfoView == false,
                   self?.isConnectingToDeviceWithId != nil {
                    self?.showConnectionError(with: "Couldn't connect to the device")
                    self?.isConnectingToDeviceWithId = nil
                }
                timer.invalidate()
            }
        }
        
        func disconnectCurrentDevice() {
            guard let connectedDeviceId = connectedDeviceInfo?.peripheralData.identifier,
                  let peripheral = getPeripheral(with: connectedDeviceId) else { return }
            
            centralManager.cancelPeripheralConnection(peripheral)
        }
        
        //MARK: Helpers
        private func getPeripheral(with id: String) -> TestablePeripheralProtocol? {
            return discoveredPeripherals.first(where: { $0.identifier.uuidString == id })
        }
       
       private func showConnectionError(with title: String) {
           connectionError = .init(title: title,
                                   okButtonAction: { [weak self] in
               self?.shoudShowBLEProblemAlert = false
               self?.connectionError = nil
           })
           shoudShowBLEProblemAlert = true
       }
    }
}

//MARK: -CBCentralManager delegate conformance and methods
extension DevicesListView.ViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            shoudShowBLEProblemAlert = true
            connectionError = .init(connectionState: central.state,
                                    okButtonAction: { [weak self] in
                self?.shoudShowBLEProblemAlert = false
                self?.connectionError = nil
            })
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier && $0.name == peripheral.name }),
           peripheral.name != nil {
            discoveredPeripherals.append(peripheral)
            peripheralsDisplayData.append(.init(peripheral: peripheral))
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        connectedDeviceInfo = .init(peripheralData: .init(peripheral: peripheral), services: [])
        shouldShowDeviceInfoView = true
        isConnectingToDeviceWithId = nil
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        deviceDisconnected = true
    }
}

//MARK: -CBPeripheral delegate conformance and methods
extension DevicesListView.ViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            service.peripheral?.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        connectedDeviceInfo?.services.append(.init(service: service))
    }
}


