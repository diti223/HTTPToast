//
//  ContentView.swift
//  HTTPToastDemo
//
//  Created by Adrian Bilescu on 11.02.2023.
//

import SwiftUI
import HTTPToast
import SwiftUI
import Combine

class ToastViewModel: ObservableObject {
    @Published private(set) var toasts: [Toast] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func request(client: HTTPClient, endpoint: String, method: HTTPMethod, headers: [String: String]?, body: Data?) {
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
    
    func showToast(_ message: String, color: Color) {
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




struct Toast: Identifiable {
    let id: UUID
    let message: String
    let color: Color
    var isShowing: Bool = true
}


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


extension View {
    func toast(viewModel: ToastViewModel) -> some View {
        self.modifier(ToastModifier(viewModel: viewModel))
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ToastViewModel()
    @State var dummyRequests: [(endpoint: String, method: HTTPMethod, headers: [String: String]?, body: Data?)] = [
        ("https://www.example.com", .get, nil, nil),
        ("https://www.example.com", .post, ["Content-Type": "application/json"], "{\"name\": \"Adrian\"}".data(using: .utf8)),
        ("https://www.example.com", .put, ["Content-Type": "application/json"], "{\"name\": \"Adrian\"}".data(using: .utf8)),
        ("https://www.example.com", .delete, nil, nil),
    ]
    
    var body: some View {
        VStack {
            // Your main content here
            
            Button(action: {
                // self.viewModel.request(client: DummyHTTPClient(), endpoint: "https://www.example.com", method: .get, headers: nil, body: nil)
                dummyRequests.shuffle()
                
                let request = self.dummyRequests.removeFirst()
                self.viewModel.request(client: DummyHTTPClient(), endpoint: request.endpoint, method: request.method, headers: request.headers, body: request.body)
                
                if self.dummyRequests.isEmpty {
                    // create new requests
                    dummyRequests = [
                        ("https://www.openai.com", .get, ["Authorization": "Bearer nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234wnduifwvhniunu84234nduifwvhniunu84234nduifwvhniunu84234", "Content-Type": "application/json"], "{\"name\": \"Adrian\"}".data(using: .utf8)),
                        ("https://www.example.com", .post, ["Content-Type": "application/json"], "{\"name\": \"Adrian\"}".data(using: .utf8)),
                        ("https://www.example.com", .put, ["Content-Type": "application/json"], "{\"name\": \"Adrian\"}".data(using: .utf8)),
                        ("https://www.example.com", .delete, nil, nil),
                    ]
                }
                
            }) {
                Text("Make Request")
            }
            
        }
        .toast(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


