//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 12.02.2023.
//

import Foundation
import SwiftUI

struct ToastModifier: ViewModifier {
    @ObservedObject var viewModel: ToastViewModel
    
    func body(content: Content) -> some View {
        ZStack {
            content
            Color.clear.ignoresSafeArea()
            VStack {
                Spacer()
                ForEach(viewModel.toasts) { toast in
                    ToastView(toast: toast)
                }
            }
        }
    }
}

public extension View {
    func toast(viewModel: ToastViewModel) -> some View {
        self.modifier(ToastModifier(viewModel: viewModel))
    }
}
