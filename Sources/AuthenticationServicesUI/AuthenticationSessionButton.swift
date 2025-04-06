//
//  AuthenticationSessionButton.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 12.03.24.
//

import SwiftUI

/// A button that triggers a authentication session
@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, visionOS 1.0, *)
public struct AuthenticationSessionButton<Label>: View where Label: View {
    let configuration: AuthenticationSessionConfiguration
    let label: Label
    let completionHandler: (Result<URL, Error>) -> Void
    
    @State private var isPresented = false
    
    /// Creates a button for a authentication session
    /// - Parameters:
    ///   - configuration: The configuration to use for the authentication session.
    ///   - label: A view that describes the purpose of the button's `action`.
    ///   - onCompletion: The closure to execute when the authentication session completes.
    public init(
        configuration: AuthenticationSessionConfiguration,
        @ViewBuilder label: () -> Label,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.configuration = configuration
        self.label = label()
        self.completionHandler = onCompletion
    }
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            label
        }
        .authenticationSession(
            isPresented: $isPresented,
            configuration: configuration,
            completionHandler: completionHandler
        )
    }
}

@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, visionOS 1.0, *)
public extension AuthenticationSessionButton where Label == Text {
    /// Creates a button for a authentication session
    /// - Parameters:
    ///   - title:  A `Text` that describes the purpose of the button's `action`.
    ///   - configuration: The configuration to use for the authentication session.
    ///   - onCompletion: The closure to execute when the authentication session completes.
    init(
        _ title: Text,
        configuration: AuthenticationSessionConfiguration,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.configuration = configuration
        self.label = title
        self.completionHandler = onCompletion
    }
    
    /// Creates a button for a authentication session
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes the purpose of the button's `action`.
    ///   - configuration: The configuration to use for the authentication session.
    ///   - onCompletion: The closure to execute when the authentication session completes.
    init(
        _ titleKey: LocalizedStringKey,
        configuration: AuthenticationSessionConfiguration,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.configuration = configuration
        self.label = Text(titleKey)
        self.completionHandler = onCompletion
    }
    
    /// Creates a button for a authentication session
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's `action`.
    ///   - configuration: The configuration to use for the authentication session.
    ///   - onCompletion: The closure to execute when the authentication session completes.
    @_disfavoredOverload
    init<S>(
        _ title: S,
        configuration: AuthenticationSessionConfiguration,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) where S: StringProtocol {
        self.configuration = configuration
        self.label = Text(title)
        self.completionHandler = onCompletion
    }
}
