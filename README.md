![Toast](https://cdn-icons-png.flaticon.com/512/284/284746.png)
# HTTPToast 
HTTPToast is a lightweight and intuitive SwiftUI component that helps you debug your HTTP requests and responses. With HTTPToast, you can quickly and easily track the performance of your network requests and identify any potential issues.
# Features
* Displays a pop-up toast with detailed information about your request and response, including the HTTP method, status code, and headers.
* Customizable appearance and behavior, so you can make HTTPToast fit your needs.
* Easy to integrate into your existing project and can be used as a custom view modifier.
# Getting Started
## Installation
HTTPToast is available through  [Swift Package Manager](https://swift.org/package-manager/) . To install it, simply add the following line to your Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/diti223/HTTPToast.git", from: "0.1.0")
]
```

And then run swift package update.
## Usage
To use HTTPToast, simply wrap your HTTPClient in a ToastHTTPClient and add the .modifier(httpClient) to your view.
Here’s an example:
```swift
struct ContentView: View {
    @State private var httpClient = ToastHTTPClient(wrapped: DummyHTTPClient())
    
    var body: some View {
        VStack {
            // Your main content here
            
            Button(action: {
                self.httpClient.request(“https://www.example.com”, method: .get, headers: nil, body: nil) { result in
                    // Do something with the result
                }
            }) {
                Text(“Make Request”)
            }
        }
        .modifier(httpClient)
    }
}
```
# Contribution
HTTPToast is an open-source project, and contributions are more than welcome. If you find a bug or have an idea for a new feature, feel free to open an issue or submit a pull request.
# License
HTTPToast is released under the  [MIT License](https://github.com/diti223/HTTPToast/blob/master/LICENSE) .
