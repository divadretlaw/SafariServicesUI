//
//  SafariManager.swift
//  SafariServicesUI
//
//  Created by David Walter on 04.07.23.
//

#if os(iOS)
import SwiftUI
import SafariServices
import UIKit
import Combine

/// Manages the presented `SFSafariViewController`s and their respective `UIWindow`s
@MainActor final class SafariManager: NSObject, ObservableObject, SFSafariViewControllerDelegate {
    static let shared = SafariManager()
    
    var safariDidFinish = PassthroughSubject<SFSafariViewController, Never>()
    private var windows: [SFSafariViewController: UIWindow] = [:]
    
    @discardableResult
    func present(
        _ safari: SFSafariViewController,
        on windowScene: UIWindowScene,
        userInterfaceStyle: UIUserInterfaceStyle = .unspecified
    ) -> SFSafariViewController {
        safari.delegate = self
        windowScene.windows.forEach { $0.endEditing(true) }
        let (window, viewController) = setup(windowScene: windowScene, userInterfaceStyle: userInterfaceStyle)
        windows[safari] = window
        viewController.present(safari, animated: true)
        return safari
    }
    
    private func setup(
        windowScene: UIWindowScene,
        userInterfaceStyle: UIUserInterfaceStyle
    ) -> (window: UIWindow, viewController: UIViewController) {
        let windowLevel = windowScene.nextWindowLevel()
        
        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = windowLevel
        window.overrideUserInterfaceStyle = userInterfaceStyle

        let viewController = UIViewController()
        window.rootViewController = viewController
        
        window.makeKeyAndVisible()
        
        return (window, viewController)
    }
    
    // MARK: - SFSafariViewControllerDelegate
    
    nonisolated func safariViewControllerDidFinish(_ safari: SFSafariViewController) {
        Task { @MainActor in
            let window = safari.view.window
            window?.resignKey()
            windows[safari] = nil
            safariDidFinish.send(safari)
        }
    }
}

private extension UIWindowScene {
    func nextWindowLevel() -> UIWindow.Level {
        guard let windowLevel = windows.map(\.windowLevel).max() else {
            return .normal
        }
        return windowLevel + 1
    }
}
#endif
