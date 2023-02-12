//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 12.02.2023.
//

import Foundation
import SwiftUI

public struct Toast: Identifiable {
    public let id: UUID
    public let message: String
    public let color: Color
    public var isShowing: Bool = true
    
    public init(id: UUID, message: String, color: Color, isShowing: Bool = true) {
        self.id = id
        self.message = message
        self.color = color
        self.isShowing = isShowing
    }
}
