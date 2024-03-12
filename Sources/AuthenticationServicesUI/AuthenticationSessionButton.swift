//
//  AuthenticationSessionButton.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 12.03.24.
//

import SwiftUI

public struct AuthenticationSessionButton<Label>: View where Label: View {
    let configuration: AuthenticationSessionConfiguration
    let label: Label
    let completionHandler: (Result<URL, Error>) -> Void
    
    @State private var isPresented = false
    
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

public extension AuthenticationSessionButton where Label == Text {
    init(
        _ title: Text,
        configuration: AuthenticationSessionConfiguration,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.configuration = configuration
        self.label = title
        self.completionHandler = onCompletion
    }
    
    init(
        _ titleKey: LocalizedStringKey,
        configuration: AuthenticationSessionConfiguration,
        onCompletion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.configuration = configuration
        self.label = Text(titleKey)
        self.completionHandler = onCompletion
    }
    
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
