# SafariServicesUI

🧭 SafariServices for SwiftUI

Enable web views and services in your app.

## Safari

### `OpenURLAction`

#### `safari(_:)`

Use `SFSafariViewController` as an action in `openURL`

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.openURL, OpenURLAction { url in
                    .safari(url)
                })
        }
    }
}
```

You can also provide an optional configuration

```swift
.environment(\.openURL, OpenURLAction { url in
    .safari(url) { configuration in
        // Apply your configuration to `configuration`
    }
})
```

#### `safariWindow(_:in:)`

Use `SFSafariViewController` as an action in `openURL` on a specific window scene.

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            WindowSceneReader { windowScene in
                ContentView()
                    .environment(\.openURL, OpenURLAction { url in
                    .safariWindow(url, in: windowScene)
                })
            }
        }
    }
}
```

### `safari(url:)`

Display an `URL` in `SFSafariViewController`.

```swift
struct ContentView: View {
    @State private var showURL: URL?
    
    var body: some View {
        Button("Show URL) {
            showURL = URL(...)
        }
        .safari(url: $showURL)
    }
}
```

You can also provide an optional configuration

```swift
.safari(url: $showURL) { configuration in
    // Apply your configuration to `configuration`
}
```

## Authentication Services

Present a authentication session via

```swift
.authenticationSession(isPresented: $isPresented, configuration: AuthenticationSessionConfiguration) { result in
    // Handle result
}
```

or use the predefined `Button`

```swift
AuthenticationSessionButton(configuration: AuthenticationSessionConfiguration) {
    Text("Authenticate")
} onCompletion: { result in
    // Handle result
}
```

## License

See [LICENSE](LICENSE)
