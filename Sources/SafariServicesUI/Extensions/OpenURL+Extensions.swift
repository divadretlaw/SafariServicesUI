//
//  OpenURL+Extensions.swift
//  SafariServicesUI
//
//  Created by David Walter on 08.01.23.
//

import SwiftUI

public extension View {
    /// Registers a handler to invoke when a open action is triggered.
    ///
    /// - Parameter handler: The closure to run for the given `URL`.
    ///   The closure takes a URL as input, and returns a `OpenURLAction.Result`
    ///   that indicates the outcome of the action.
    func openURL(handler: @escaping (URL) -> OpenURLAction.Result) -> some View {
        environment(\.openURL, OpenURLAction(handler: handler))
    }
}

#if os(iOS) || os(tvOS) || os(visionOS)
import WindowReader

public extension View {
    /// Registers a handler to invoke when a view wants to open a url.
    ///
    /// - Parameter handler: The closure to run for the given `URL` and `UIWindowScene`.
    ///   The closure takes a URL as input, and returns a `OpenURLAction.Result`
    ///   that indicates the outcome of the action.
    func openURL(handler: @escaping (URL, UIWindowScene?) -> OpenURLAction.Result) -> some View {
        modifier(WindowSceneOpenURL(handler: handler))
    }
}

struct WindowSceneOpenURL: ViewModifier {
    var handler: (URL, UIWindowScene?) -> OpenURLAction.Result
    
    @State private var windowScene: UIWindowScene?
    
    func body(content: Content) -> some View {
        content
            .onWindowChange(initial: true) { window in
                windowScene = window.windowScene
            }
            .openURL { url in
                handler(url, windowScene)
            }
    }
}
#endif
