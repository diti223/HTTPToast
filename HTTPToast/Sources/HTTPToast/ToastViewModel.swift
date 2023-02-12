//
//  File.swift
//  
//
//  Created by Adrian Bilescu on 12.02.2023.
//

import Foundation
import Combine
import SwiftUI

public class ToastViewModel: ObservableObject {
    @Published private(set) var toasts: [Toast] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {}
    
    public func request(client: HTTPClient, endpoint: String, method: HTTPMethod, headers: [String: String]?, body: Data?) {
        let requestDescription = "\(method.rawValue.uppercased()) \(endpoint)"
        client.requestPublisher(endpoint: endpoint, method: method, headers: headers, body: body)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.showToast("\(requestDescription)\n\(error)", color: .red)
                }
            }, receiveValue: { response in
                self.showToast("\(requestDescription)\n\(response)", color: .green)
            })
            .store(in: &cancellables)
        showToast("\(requestDescription)", color: .blue)
    }
    
    public func showToast(_ message: String, color: Color) {
        let toast = Toast(id: UUID(), message: message, color: color)
        self.toasts.append(toast)
        
        let delay = Double(message.count) / 10 + 3
        
        Just(toast)
            .delay(for: RunLoop.SchedulerTimeType.Stride(delay), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] toast in
                guard let index = self?.toasts.firstIndex(where: { $0.id == toast.id }) else {
                    return
                }
                self?.toasts[index].isShowing = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.toasts.remove(at: index)
                }
            })
            .store(in: &cancellables)
    }
    
}
