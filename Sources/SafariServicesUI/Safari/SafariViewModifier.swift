//
//  SafariViewModifier.swift
//  SafariServicesUI
//
//  Created by David Walter on 04.07.23.
//

#if os(iOS)
import SwiftUI
import WindowSceneReader
import SafariServices

@MainActor public extension View {
    /// Presents a `SFSafariViewController` using the given url.
    ///
    /// - Parameters:
    ///   - url: A binding to an optional `url` for the `SFSafariViewController`.
    ///          When the `url` is non-`nil` and the given `url` is supported the
    ///          `SFSafariViewController` will be displayed.
    ///
    /// The `SFSafariViewController` will be displayed in its own `UIWindow` within the current view's `UIWindowScene`.
    func safari(url: Binding<URL?>) -> some View {
        modifier(SafariViewModifier(url: url, configure: nil))
    }

    /// Presents a `SFSafariViewController` using the given url.
    ///
    /// - Parameters:
    ///   - url: A binding to an optional `url` for the `SFSafariViewController`.
    ///          When the `url` is non-`nil` and the given `url` is supported the
    ///          `SFSafariViewController` will be displayed.
    ///   - configure: A closure to configure the presentation of `SFSafariViewController`.
    ///
    /// The `SFSafariViewController` will be displayed in its own `UIWindow` within the current view's `UIWindowScene`.
    func safari(
        url: Binding<URL?>,
        configure: @MainActor @Sendable @escaping (inout SafariConfiguration) -> Void
    ) -> some View {
        modifier(SafariViewModifier(url: url, configure: configure))
    }
}

private struct SafariViewModifier: ViewModifier {
    @Binding var url: URL?
    let configure: ((inout SafariConfiguration) -> Void)?

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.safariConfiguration) private var safariConfiguration

    @ObservedObject private var safariManager = SafariManager.shared

    @State private var presentingSafari: SFSafariViewController?

    func body(content: Content) -> some View {
        content
            .background {
                WindowSceneReader { windowScene in
                    Color.clear
                        .task(id: url) {
                            await dismiss()
                            guard let url else { return }
                            show(with: url, on: windowScene)
                        }
                        .onReceive(safariManager.safariDidFinish) { safari in
                            if safari == presentingSafari {
                                presentingSafari = nil
                                url = nil
                            }
                        }
                }
            }
    }

    func show(with url: URL, on windowScene: UIWindowScene) {
        guard url.supportsSafari else { return }

        var config = safariConfiguration ?? SafariConfiguration()
        configure?(&config)
        let safari = SFSafariViewController(url: url, configuration: config)

        presentingSafari = safariManager.present(safari, on: windowScene, userInterfaceStyle: config.userInterfaceStyle(with: colorScheme))
    }

    func dismiss() async {
        guard let safari = presentingSafari else { return }
        presentingSafari = nil
        await withCheckedContinuation { continuation in
            safari.dismiss(animated: true) {
                continuation.resume()
            }
        }
        safariManager.dismiss(safari: safari)
    }
}

@available(iOS 17, *)
#Preview {
    @Previewable @State var url: URL?
    NavigationView {
        List {
            Button {
                url = URL(string: "https://davidwalter.at")
            } label: {
                Text("Show Safari")
            }
        }
        .navigationTitle("Preview")
        .safari(url: $url) { configuration in
            configuration.overrideUserInterfaceStyle = .dark
        }
    }
    .navigationViewStyle(.stack)
}
#endif
