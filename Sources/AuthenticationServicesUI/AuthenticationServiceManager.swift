//
//  AuthenticationServiceManager.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 11.03.24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
import Combine
import AuthenticationServices

@available(iOS 12.0, macOS 10, tvOS 16.0, watchOS 6.2, *)
@MainActor final class AuthenticationServiceManager: NSObject, ObservableObject {
    @Published var session: ASWebAuthenticationSession?
    #if canImport(UIKit) && !os(watchOS)
    var windowScene: UIWindowScene?
    #endif
    var didFinish: PassthroughSubject<Result<URL, Error>, Never>
    
    override init() {
        self.didFinish = PassthroughSubject()
        super.init()
    }
    
    #if canImport(UIKit) && !os(watchOS)
    func createSession(for windowScene: UIWindowScene, with configuration: AuthenticationSessionConfiguration) {
        self.windowScene = windowScene
        
        let session: ASWebAuthenticationSession
        if #available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, *) {
            session = ASWebAuthenticationSession(url: configuration.url, callback: configuration.callback.create()) { [weak self] url, error in
                guard let self else { return }
                Task { @MainActor in
                    self.handleCallback(url: url, error: error)
                }
            }
        } else {
            session = ASWebAuthenticationSession(url: configuration.url, callbackURLScheme: configuration.callback.rawValue) { [weak self] url, error in
                guard let self else { return }
                Task { @MainActor in
                    self.handleCallback(url: url, error: error)
                }
            }
        }
        
        #if !os(tvOS) && !os(watchOS)
        session.presentationContextProvider = self
        #endif
        self.session = session
    }
    #else
    func createSession(with configuration: AuthenticationSessionConfiguration) {        
        let session: ASWebAuthenticationSession
        if #available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, *) {
            session = ASWebAuthenticationSession(url: configuration.url, callback: configuration.callback.create()) { [weak self] url, error in
                guard let self else { return }
                Task { @MainActor in
                    self.handleCallback(url: url, error: error)
                }
            }
        } else {
            session = ASWebAuthenticationSession(url: configuration.url, callbackURLScheme: configuration.callback.rawValue) { [weak self] url, error in
                guard let self else { return }
                Task { @MainActor in
                    self.handleCallback(url: url, error: error)
                }
            }
        }
        
        #if !os(tvOS) && !os(watchOS)
        session.presentationContextProvider = self
        #endif
        self.session = session
    }
    #endif
    
    func handleCallback(url: URL?, error: (any Error)?) {
        if let error {
            self.didFinish.send(.failure(error))
        } else if let url {
            self.didFinish.send(.success(url))
        } else {
            self.didFinish.send(completion: .finished)
        }
    }
}

#if !os(tvOS) && !os(watchOS)
extension AuthenticationServiceManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        #if canImport(UIKit)
        if let windowScene {
            ASPresentationAnchor(windowScene: windowScene)
        } else {
            ASPresentationAnchor()
        }
        #else
        ASPresentationAnchor()
        #endif
    }
}
#endif