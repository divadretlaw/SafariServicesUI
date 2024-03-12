//
//  AuthenticationSessionConfiguration.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 11.03.24.
//

import Foundation
import AuthenticationServices

@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, *)
public struct AuthenticationSessionConfiguration: Sendable {
    let url: URL
    let callback: Callback
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
            /// (Mis)Using ``Callback/https`` because it will result in `nil`
            self.callback = .https(host: "", path: "")
        }
        self.additionalHeaderFields = nil
        self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
    }
    
    @available(iOS 17.4, *)
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

    public enum Callback: Sendable {
        case customScheme(_ customScheme: String)
        case https(host: String, path: String)
        
        var rawValue: String? {
            switch self {
            case let .customScheme(customScheme):
                return customScheme
            case .https:
                return nil
            }
        }
        
        @available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, *)
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
