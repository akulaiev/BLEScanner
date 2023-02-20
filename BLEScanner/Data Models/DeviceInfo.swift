//
//  DeviceInfo.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 19.02.2023.
//

import CoreBluetooth

struct DeviceInfo {
    let peripheralData: PeripheralData
    var services: [Service]
    
    struct Service: Identifiable {
        let id = UUID()
        let name: String
        let characteristicsProperties: [String]
        
        init(service: CBService) {
            self.name = service.uuid.description
            self.characteristicsProperties = service.characteristics?.map({ $0.properties.textualRepresentation }) ?? []
        }
        
        init(name: String,
             characteristicsProperties: [String]?) {
            self.name = name
            self.characteristicsProperties = characteristicsProperties ?? []
        }
    }
}
