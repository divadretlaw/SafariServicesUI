//
//  MainActor+Extensions.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 06.04.24.
//

import Foundation

extension MainActor {
    /// Execute the given body closure on the main actor without enforcing MainActor isolation.
    ///
    /// The method will be dispatched in sync to the main-thread if its on a non-main thread.
    @_unavailableFromAsync
    static func runSync<T>(_ body: @MainActor () throws -> T) rethrows -> T where T: Sendable {
        if Thread.isMainThread {
            try MainActor.assumeIsolated(body)
        } else {
            try DispatchQueue.main.sync {
                try MainActor.assumeIsolated(body)
            }
        }
    }
}
