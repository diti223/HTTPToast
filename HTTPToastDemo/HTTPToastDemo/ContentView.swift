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


