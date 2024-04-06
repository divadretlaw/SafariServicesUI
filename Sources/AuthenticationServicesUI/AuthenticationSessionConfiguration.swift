//
//  AuthenticationSessionConfiguration.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 11.03.24.
//

import Foundation
import AuthenticationServices

@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, visionOS 1.0, *)
/// Configuration values for an authentication session
public struct AuthenticationSessionConfiguration: Sendable {
    let url: URL
    let callback: Callback?
    let additionalHeaderFields: [String: String]?
    let prefersEphemeralWebBrowserSession: Bool
    
    public init(
        url: URL,
        callbackURLScheme: String?,
        prefersEphemeralWebBrowserSession: Bool = false
    ) {
        self.url = url
        if let callbackURLScheme {
            self.callback = .customScheme(callbackURLScheme)
        } else {
            self.callback = nil
        }
        self.additionalHeaderFields = nil
        self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
    }
    
    @available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, visionOS 1.1, *)
    public init(
        url: URL,
        callback: AuthenticationSessionConfiguration.Callback,
        additionalHeaderFields: [String: String]? = nil,
        prefersEphemeralWebBrowserSession: Bool = false
    ) {
        self.url = url
        self.callback = callback
        self.additionalHeaderFields = additionalHeaderFields
        self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
    }

    /// An object used to evaluate navigation events in an authentication session.
    /// When the session navigates to a matching URL, it will pass the URL to the session completion handler.
    public enum Callback: Sendable {
        /// Creates a callback object that matches against URLs with the given custom scheme.
        case customScheme(_ customScheme: String)
        /// Creates a callback object that matches against HTTPS URLs with the given host and path.
        ///
        /// - Parameters:
        ///     - host: The host that the app expects in the callback URL.
        ///             The host must be associated with the app using associated web credentials domains.
        ///     - path: The path that the app expects in the callback URL.
        case https(host: String, path: String)
        
        var rawValue: String? {
            switch self {
            case let .customScheme(customScheme):
                return customScheme
            case .https:
                return nil
            }
        }
        
        @available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, visionOS 1.1, *)
        /// Create the underlying `ASWebAuthenticationSession.Callback`
        func create() -> ASWebAuthenticationSession.Callback {
            switch self {
            case let .customScheme(customScheme):
                return .customScheme(customScheme)
            case let .https(host, path):
                return .https(host: host, path: path)
            }
        }
    }
}
