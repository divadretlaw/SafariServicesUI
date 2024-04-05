//
//  WebAuthenticationSession+Extensions.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 06.04.24.
//

import SwiftUI
import AuthenticationServices

@available(iOS 16.4, macOS 13.3, watchOS 9.4, tvOS 16.4, *)
extension WebAuthenticationSession {
    public func authenticate(with configuration: AuthenticationSessionConfiguration) async throws -> URL {
        if #available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, visionOS 1.1, *), let callback = configuration.callback {
            return try await authenticate(
                using: configuration.url,
                callback: callback.create(),
                preferredBrowserSession: configuration.prefersEphemeralWebBrowserSession ? .ephemeral : nil,
                additionalHeaderFields: configuration.additionalHeaderFields ?? [:]
            )
        } else if let callbackURLScheme = configuration.callback?.rawValue {
            return try await authenticate(
                using: configuration.url,
                callbackURLScheme: callbackURLScheme,
                preferredBrowserSession: configuration.prefersEphemeralWebBrowserSession ? .ephemeral : nil
            )
        } else {
            throw ASAuthorizationError(.notHandled, userInfo: ["Reason": "No callback provided"])
        }
    }
}
