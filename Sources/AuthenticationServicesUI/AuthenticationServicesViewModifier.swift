//
//  AuthenticationServicesViewModifier.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 10.03.24.
//

import SwiftUI
import WindowSceneReader
import AuthenticationServices

@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, visionOS 1.0, *)
public extension View {
    /// Presents an authentication session when a binding to a Boolean value that you provide is true.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the authentication session
    ///   - configuration: The configuration to authenticate with.
    ///   - completionHandler:Tthe completion handler which is called when the session is completed successfully or canceled by user.
    @MainActor func authenticationSession(
        isPresented: Binding<Bool>,
        configuration: AuthenticationSessionConfiguration,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> some View {
        modifier(
            AuthenticationServicesViewModifier(
                isPresented: isPresented,
                configuration: configuration,
                completionHandler: completionHandler
            )
        )
    }
}

@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, visionOS 1.0, *)
private struct AuthenticationServicesViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    let configuration: AuthenticationSessionConfiguration
    let completionHandler: (Result<URL, Error>) -> Void
    
    @StateObject private var manager = AuthenticationServiceManager()
    
    func body(content: Content) -> some View {
        content
            #if canImport(UIKit) && !os(watchOS)
            .background {
                WindowSceneReader { windowScene in
                    Color.clear
                        .onTrigger(of: isPresented) {
                            manager.createSession(for: windowScene, with: configuration)
                        }
                }
            }
            #else
            .onTrigger(of: isPresented) {
                manager.createSession(with: configuration)
            }
            #endif
            .onDisappear {
                guard let session = manager.session else { return }
                #if !os(tvOS)
                session.cancel()
                #endif
            }
            .onReceive(manager.$session) { session in
                guard let session else { return }
                if !session.start() {
                    isPresented = false
                }
            }
            .onReceive(manager.didFinish) { result in
                completionHandler(result)
                isPresented = false
            }
    }
}
