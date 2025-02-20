//
//  OpenURLAction+Safari.swift
//  SafariServicesUI
//
//  Created by David Walter on 30.05.23.
//

#if os(iOS)
import SwiftUI
import URLExtensions
import SafariServices

public extension OpenURLAction.Result {
    /// The handler tries to open the original URL with `SFSafariViewController`.
    ///
    /// - Parameter url: The `URL` that the handler asks `SFSafariViewController` to open.
    ///
    /// If the `URL` cannot be opened by `SFSafariViewController` then the handler
    /// asks the system to open the original URL.
    @MainActor static func safari(
        _ url: URL
    ) -> Self {
        guard url.supportsSafari else {
            // URL doesn't support Safari. Abort.
            return .systemAction
        }
        
        guard let scene = UIApplication.shared.keyWindowScene else {
            // No window scene was found. Abort.
            return .systemAction
        }
        
        let window = scene.windows.first { $0.isKeyWindow } ?? scene.windows.first
        
        guard let rootViewController = window?.rootViewController else {
            // Window has no root view controller. Abort.
            return .systemAction
        }
        
        let safari = SFSafariViewController(url: url)
        if window?.traitCollection.horizontalSizeClass == .regular {
            safari.modalPresentationStyle = .pageSheet
        }
        
        guard rootViewController.presentedViewController == nil else {
            // rootViewController is already presenting, so we show Safari in a window instead
            return safariWindow(url, in: scene)
        }
        
        rootViewController.present(safari, animated: true)
        return .handled
    }
    
    /// The handler tries to open the original URL with `SFSafariViewController`.
    ///
    /// - Parameters:
    ///     - url: The `URL` that the handler asks `SFSafariViewController` to open.
    ///     - configure: Callback to configure `SFSafariViewController`.
    ///
    /// If the `URL` cannot be opened by `SFSafariViewController` then the handler
    /// asks the system to open the original URL.
    @MainActor static func safari(
        _ url: URL,
        configure: @MainActor @Sendable (inout SafariConfiguration) -> Void
    ) -> Self {
        guard url.supportsSafari else {
            // URL doesn't support Safari. Abort.
            return .systemAction
        }
        
        guard let scene = UIApplication.shared.keyWindowScene else {
            // No window scene was found. Abort.
            return .systemAction
        }
        
        let window = scene.windows.first { $0.isKeyWindow } ?? scene.windows.first
        
        guard let rootViewController = window?.rootViewController else {
            // Window has no root view controller. Abort.
            return .systemAction
        }
        
        guard rootViewController.presentedViewController == nil else {
            // rootViewController is already presenting, so we show Safari in a window instead
            return .safariWindow(url, in: scene, configure: configure)
        }
        
        var config = SafariConfiguration()
        configure(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        if config.modalPresentationStyle == .automatic, window?.traitCollection.horizontalSizeClass == .regular {
            safari.modalPresentationStyle = .pageSheet
        } else {
            safari.modalPresentationStyle = config.modalPresentationStyle
        }
        safari.overrideUserInterfaceStyle = config.overrideUserInterfaceStyle
        
        rootViewController.present(safari, animated: true)
        return .handled
    }
    
    /// The handler tries to open the original URL with `SFSafariViewController`.
    ///
    /// - Parameters:
    ///     - url: The `URL` that the handler asks `SFSafariViewController` to open.
    ///     - windowScene: The `UIWindowScene` to show `SFSafariViewController` in.
    ///
    /// If the `URL` cannot be opened by `SFSafariViewController` then the handler
    /// asks the system to open the original URL.
    @MainActor static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene?
    ) -> Self {
        guard url.supportsSafari else {
            // URL doesn't support Safari. Abort.
            return .systemAction
        }
        
        guard let windowScene else {
            return safari(url)
        }
        
        return safariWindow(url, in: windowScene)
    }
    
    /// The handler tries to open the original URL with `SFSafariViewController`.
    ///
    /// - Parameters:
    ///     - url: The `URL` that the handler asks `SFSafariViewController` to open.
    ///     - windowScene: The `UIWindowScene` to show `SFSafariViewController` in.
    ///     - configure: Callback to configure `SFSafariViewController`.
    ///
    /// If the `URL` cannot be opened by `SFSafariViewController` then the handler
    /// asks the system to open the original URL.
    @MainActor static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene?,
        configure: @MainActor @Sendable (inout SafariConfiguration) -> Void
    ) -> Self {
        guard url.supportsSafari else {
            // URL doesn't support Safari. Abort.
            return .systemAction
        }
        
        guard let windowScene else {
            return safari(url)
        }
        
        return safariWindow(url, in: windowScene, configure: configure)
    }
}

extension OpenURLAction.Result {
    @MainActor static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene
    ) -> Self {
        guard url.supportsSafari else {
            // URL doesn't support Safari. Abort.
            return .systemAction
        }
        
        let safari = SFSafariViewController(url: url)
        
        SafariManager.shared.present(safari, on: windowScene)
        
        return .handled
    }
    
    @MainActor static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene,
        configure: @MainActor @Sendable (inout SafariConfiguration) -> Void
    ) -> Self {
        guard url.supportsSafari else {
            // URL doesn't support Safari. Abort.
            return .systemAction
        }
        
        var config = SafariConfiguration()
        configure(&config)
        
        let safari = SFSafariViewController(url: url, configuration: config.configuration)
        safari.preferredBarTintColor = config.preferredBarTintColor
        safari.preferredControlTintColor = config.preferredControlTintColor
        safari.dismissButtonStyle = config.dismissButtonStyle
        safari.overrideUserInterfaceStyle = config.overrideUserInterfaceStyle
        
        SafariManager.shared.present(safari, on: windowScene, userInterfaceStyle: config.overrideUserInterfaceStyle)
        
        return .handled
    }
}

private extension UIApplication {
    /// Returns the first active connected `UIWindowScene`
    var keyWindowScene: UIWindowScene? {
        let scenes = connectedScenes
        .compactMap { $0 as? UIWindowScene }
        
        return scenes.first { $0.activationState == .foregroundActive }
        ?? scenes.first { $0.activationState == .foregroundInactive }
        ?? scenes.first
    }
}

struct OpenURLActionSafari_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .openURL { url, _ in
                .safari(url) { configuration in
                    configuration.modalPresentationStyle = .fullScreen
                    configuration.overrideUserInterfaceStyle = .dark
                }
            }
            .previewDisplayName(".safari")
        
        VStack {
            Text("Sheet Host")
        }
        .sheet(isPresented: .constant(true)) {
            Preview()
                .interactiveDismissDisabled()
        }
        .openURL { url, _ in
            .safari(url) { configuration in
                configuration.modalPresentationStyle = .fullScreen
                configuration.overrideUserInterfaceStyle = .dark
            }
        }
        .previewDisplayName("Safari within Sheet")
        
        Preview()
            .openURL { url, windowScene in
                .safariWindow(url, in: windowScene) { configuration in
                    configuration.modalPresentationStyle = .fullScreen
                    configuration.overrideUserInterfaceStyle = .dark
                }
            }
            .previewDisplayName(".safariWindow")
    }
    
    struct Preview: View {
        @Environment(\.openURL) private var openURL
        
        var body: some View {
            NavigationView {
                List {
                    Button {
                        guard let url = URL(string: "https://davidwalter.at") else {
                            return
                        }
                        openURL(url)
                    } label: {
                        Text("Show Safari")
                    }
                }
                .navigationTitle("Preview")
            }
            .navigationViewStyle(.stack)
        }
    }
}
#endif
