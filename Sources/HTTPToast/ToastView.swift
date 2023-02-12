//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 12.02.2023.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let toast: Toast
    
    var body: some View {
        HStack {
            Text(toast.message)
                .foregroundColor(.white)
                .font(.caption.bold())
                .padding()
                .background(toast.color)
                .cornerRadius(20)
                .opacity(self.toast.isShowing ? 1 : 0)
                .offset(y: self.toast.isShowing ? 0 : -20)
                .animation(.easeOut(duration: self.toast.isShowing ? 0.2 : 1.5), value: self.toast.isShowing)
        }
    }
}
