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
@MainActor final class SafariManager: NSObject, ObservableObject, SFSafariViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
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
        safari.presentationController?.delegate = self

        windowScene.windows.forEach { $0.endEditing(true) }

        let (window, viewController) = setup(windowScene: windowScene, userInterfaceStyle: userInterfaceStyle)
        windows[safari] = window

        if safari.modalPresentationStyle == .automatic, window.traitCollection.horizontalSizeClass == .regular {
            safari.modalPresentationStyle = .pageSheet
        }

        if safari.isModalInPresentation {
            UIView.animate(withDuration: 0.3) {
                viewController.present(SafariHostingController(safari: safari), animated: true)
                window.backgroundColor = UIColor(white: 0.51, alpha: 0.8)
            }
        } else {
            viewController.present(safari, animated: true)
        }

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
        // Hide the default shadow
        window.subviews.forEach { $0.isHidden = true }

        return (window, viewController)
    }

    private func dismiss(safari: SFSafariViewController) {
        let window = safari.view.window
        UIView.animate(withDuration: 0.3) {
            window?.backgroundColor = nil
        }
        window?.resignKey()
        windows[safari] = nil
        safariDidFinish.send(safari)
    }

    // MARK: - SFSafariViewControllerDelegate
    
    nonisolated func safariViewControllerDidFinish(_ safari: SFSafariViewController) {
        Task { @MainActor in
            dismiss(safari: safari)
        }
    }

    // MARK: - UIAdaptivePresentationControllerDelegate

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard let safari = presentationController.presentedViewController as? SFSafariViewController else { return }
        dismiss(safari: safari)
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
