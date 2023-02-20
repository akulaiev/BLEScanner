//
//  BLEScannerTests.swift
//  BLEScannerTests
//
//  Created by Anna Koulaeva on 20.02.2023.
//

import Quick
import Nimble
import CoreBluetooth
@testable import BLEScanner

class DevicesListViewModelTests: QuickSpec {
    var sut: DevicesListView.ViewModel!
    
    override func spec() {
        describe("The DevicesListView ViewModel") {
            beforeEach {
                self.sut = DevicesListView.ViewModel(managerState: CBManagerState.poweredOn)
            }
            
            describe("scanConnections() tests") {
                describe("if centralManager state is not powered on") {
                    it("should return") {
                        //Given
                        self.sut = .init(managerState: .poweredOff)
                        // When
                        self.sut.scanConnections()
                        // Then
                        expect(self.sut.isScanningForDevices).to(beFalse())
                    }
                }
                
                describe("if centralManager state is powered on") {
                    it("should start scanning") {
                        // When
                        self.sut.scanConnections()
                        // Then
                        expect(self.sut.isScanningForDevices).to(beTrue())
                    }
                }
            }
            
            describe("stopScanningForConnections() tests") {
                describe("when stop scanning is called") {
                    it("should stop scanning for connections") {
                        // When
                        self.sut.stopScanningForConnections()
                        // Then
                        expect(self.sut.isScanningForDevices).to(beFalse())
                    }
                }
            }
            
            describe("connectTo(deviceId: String) tests") {
                describe("when connection is started") {
                    it("should stop scanning for connections") {
                        // When
                        self.sut.connectTo(deviceId: "Random Id")
                        // Then
                        expect(self.sut.isScanningForDevices).to(beFalse())
                    }
                    
                    describe("peripheral with given id is correct") {
                        it("should call connect to peripheral with the found data") {
                            //Given
                            var testPeripherals: [TestablePeripheral] = [.init(name: "peripheral #1", idString: "111"),
                                                                         .init(name: "peripheral #2", idString: "222")]
                            let targetPeripheral: TestablePeripheral = .init(name: "peripheral #3", idString: "333")
                            testPeripherals.append(targetPeripheral)
                            self.sut = .init(discoveredPeripherals: testPeripherals)
                            
                            //When
                            self.sut.connectTo(deviceId: targetPeripheral.identifier.uuidString)
                            
                            //Then
                            expect(self.sut.shoudShowBLEProblemAlert).to(beFalse())
                        }
                    }
                    
                    describe("peripheral with given id is incorrect") {
                        it("should display error") {
                            //Given
                            var testPeripherals: [TestablePeripheral] = [.init(name: "peripheral #1", idString: "111"),
                                                                         .init(name: "peripheral #2", idString: "222")]
                            let targetPeripheral: TestablePeripheral = .init(name: "peripheral #3", idString: "333")
                            self.sut = .init(discoveredPeripherals: testPeripherals)
                            
                            //When
                            self.sut.connectTo(deviceId: targetPeripheral.identifier.uuidString)
                            
                            //Then
                            expect(self.sut.shoudShowBLEProblemAlert).to(beTrue())
                            expect(self.sut.connectionError?.title).to(equal("Couldn't find the device"))
                        }
                    }
                }
            }
            
            describe("disconnectCurrentDevice() tests") {
                describe("when connected device is nil") {
                    it("should not call disconnect") {
                        // Given
                        self.sut.connectedDeviceInfo = nil
                        //When
                        self.sut.disconnectCurrentDevice()
                        // Then
                        expect(self.sut.deviceDisconnected).to(beFalse())
                    }
                    
                    describe("peripheral with given id is not connected") {
                        it("should not call disconnect") {
                            //Given
                            let testPeripherals: [TestablePeripheral] = [.init(name: "peripheral #1", idString: "111"),
                                                                         .init(name: "peripheral #2", idString: "222")]
                            self.sut = .init(discoveredPeripherals: testPeripherals)
                            self.sut.connectedDeviceInfo = .init(peripheralData: .init(name: "peripheral #3", description: "Some description", identifier: "Some id"), services: [])
                            
                            //When
                            self.sut.disconnectCurrentDevice()
                            
                            //Then
                            expect(self.sut.deviceDisconnected).to(beFalse())
                        }
                    }
                }
            }
        }
    }
}
