//
//  UIConstants.swift
//  BLEScanner
//
//  Created by Anna Koulaeva on 18.02.2023.
//

import SwiftUI

public struct UIConstants {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let mainColor: Color = .init(red: 0.15, green: 0.25, blue: 0.9)
    
    enum Padding {
        static let small: CGFloat = 8.0
        static let medium: CGFloat = 20.0
        static let large: CGFloat = 24.0
        static let xlarge: CGFloat = 32.0
    }
    
    enum CornerRadius {
        static let small: CGFloat = 8.0
        static let normal: CGFloat = 16.0
        static let large: CGFloat = 24.0
    }
}
