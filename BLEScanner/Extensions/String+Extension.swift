//
//  String+Extension.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 20.02.2023.
//

import Foundation

extension String: Identifiable {
    public var id: UUID {
        UUID()
    }
}
