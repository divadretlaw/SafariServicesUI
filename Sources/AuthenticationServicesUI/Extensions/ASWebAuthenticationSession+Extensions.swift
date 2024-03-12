//
//  ASWebAuthenticationSession+Extensions.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 12.03.24.
//

import Foundation
import AuthenticationServices

@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, visionOS 1.0, *)
extension ASWebAuthenticationSession {
    convenience init(configuration: AuthenticationSessionConfiguration, completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler) {
        if #available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, visionOS 1.1, *), let callback = configuration.callback {
            self.init(url: configuration.url, callback: callback.create(), completionHandler: completionHandler)
        } else {
            self.init(url: configuration.url, callbackURLScheme: configuration.callback?.rawValue, completionHandler: completionHandler)
        }
    }
}
