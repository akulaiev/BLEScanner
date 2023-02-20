//
//  CustomErrors.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 18.02.2023.
//

import Foundation
import CoreBluetooth

protocol CustomErrorProtocol: LocalizedError {
    var title: String { get }
    var description: String { get }
    var okButtonAction: (() -> Void)? { get }
}

public struct ConnectionError: CustomErrorProtocol {
    var title: String
    var description: String
    var okButtonAction: (() -> Void)?
    
    init(title: String = "Oops! Something went wrong",
         description: String = "Please try again later",
         okButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.description = description
        self.okButtonAction = okButtonAction
    }
    
    init?(connectionState: CBManagerState,
          okButtonAction: (() -> Void)?) {
        switch connectionState {
        case .unsupported:
            self.title = "Bluetooth is not supported by your device"
            self.description = "Try running on another device"
        case .poweredOff:
            self.title = "Bluetoth is powered off"
            self.description = "Please turn on Bluetooth and reload the app"
        case .poweredOn:
            return nil
        default:
            self.title = "Oops! Something went wrong"
            self.description = "Please try again later"
        }
        
        self.okButtonAction = okButtonAction
    }
}
