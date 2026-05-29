//
//  OpenURLAction+SafariWindow.swift
//  SafariServicesUI
//
//  Created by David Walter on 30.05.23.
//

#if os(iOS)
import SwiftUI
import URLExtensions
import SafariServices

@MainActor public extension OpenURLAction.Result {
    /// The handler tries to open the original URL with `SFSafariViewController`.
    ///
    /// - Parameters:
    ///     - url: The `URL` that the handler asks `SFSafariViewController` to open.
    ///     - windowScene: The `UIWindowScene` to show `SFSafariViewController` in.
    ///
    /// If the `URL` cannot be opened by `SFSafariViewController` then the handler
    /// asks the system to open the original URL.
    static func safari(
        _ url: URL,
        in windowScene: UIWindowScene?
    ) -> Self {
        guard let windowScene else {
            return .safari(url)
        }
        return .safari(url, in: windowScene)
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
    static func safari(
        _ url: URL,
        in windowScene: UIWindowScene?,
        configure: @MainActor @Sendable (inout SafariConfiguration) -> Void
    ) -> Self {
        guard let windowScene else {
            return .safari(url)
        }
        return .safari(url, in: windowScene, configure: configure)
    }

    static func safari(
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

    static func safari(
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
        let safari = SFSafariViewController(url: url, configuration: config)

        SafariManager.shared.present(safari, on: windowScene, userInterfaceStyle: config.overrideUserInterfaceStyle)
        return .handled
    }
}

#if DEBUG
#Preview("Safari in window") {
    Preview()
        .openURL { url, windowScene in
            .safari(url, in: windowScene) { configuration in
                configuration.modalPresentationStyle = .fullScreen
                configuration.overrideUserInterfaceStyle = .dark
            }
        }
}

#Preview("Safari within Sheet") {
    VStack {
        Text("Sheet Host")
    }
    .sheet(isPresented: .constant(true)) {
        Preview()
            .interactiveDismissDisabled()
    }
    .openURL { url, windowScene in
        .safari(url, in: windowScene) { configuration in
            configuration.modalPresentationStyle = .fullScreen
            configuration.overrideUserInterfaceStyle = .dark
        }
    }
}
#endif
#endif
