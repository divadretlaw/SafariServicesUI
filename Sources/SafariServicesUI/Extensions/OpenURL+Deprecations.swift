//
//  OpenURL+Deprecations.swift
//  SafariServicesUI
//
//  Created by David Walter on 29.05.26.
//

import SwiftUI

@MainActor public extension OpenURLAction.Result {
    @available(*, deprecated, renamed: "safari(_:in:)")
    static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene?
    ) -> Self {
        safari(url, in: windowScene)
    }

    @available(*, deprecated, renamed: "safari(_:in:configure:)")
    static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene?,
        configure: @MainActor @Sendable (inout SafariConfiguration) -> Void
    ) -> Self {
        safari(url, in: windowScene, configure: configure)
    }

    @available(*, deprecated, renamed: "safari(_:in:)")
    static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene
    ) -> Self {
        safari(url, in: windowScene)
    }

    @available(*, deprecated, renamed: "safari(_:in:configure:)")
    static func safariWindow(
        _ url: URL,
        in windowScene: UIWindowScene,
        configure: @MainActor @Sendable (inout SafariConfiguration) -> Void
    ) -> Self {
        safari(url, in: windowScene, configure: configure)
    }
}
