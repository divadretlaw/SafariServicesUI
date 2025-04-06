//
//  SafariConfiguration.swift
//  SafariServicesUI
//
//  Created by David Walter on 04.07.23.
//

#if os(iOS)
import Foundation
import UIKit
import SwiftUI
import SafariServices

/// Configuration for `SFSafariViewController`
@MainActor public struct SafariConfiguration: Sendable {
    /// A configuration object that defines how a Safari view controller should be initialized.
    public var configuration: SFSafariViewController.Configuration
    /// The color to tint the background of the navigation bar and the toolbar.
    public var preferredBarTintColor: UIColor?
    /// The color to tint the control buttons on the navigation bar and the toolbar.
    public var preferredControlTintColor: UIColor?
    /// The style of dismiss button to use in the navigation bar to close the Safari view controller.
    public var dismissButtonStyle: SFSafariViewController.DismissButtonStyle
    /// The presentation style for modal view controllers.
    public var modalPresentationStyle: UIModalPresentationStyle
    /// A Boolean value indicating whether the view controller enforces a modal behavior.
    public var isModalInPresentation: Bool
    /// The user interface style adopted by the view controller and all of its children.
    public var overrideUserInterfaceStyle: UIUserInterfaceStyle
    
    init() {
        self.configuration = SFSafariViewController.Configuration()
        self.preferredBarTintColor = nil
        self.preferredControlTintColor = .tintColor
        self.dismissButtonStyle = .done
        self.modalPresentationStyle = .automatic
        self.isModalInPresentation = false
        self.overrideUserInterfaceStyle = .unspecified
    }
    
    public init(
        configuration: SFSafariViewController.Configuration = SFSafariViewController.Configuration(),
        preferredBarTintColor: UIColor? = nil,
        preferredControlTintColor: UIColor? = .tintColor,
        dismissButtonStyle: SFSafariViewController.DismissButtonStyle = .done,
        modalPresentationStyle: UIModalPresentationStyle = .automatic,
        isModalInPresentation: Bool,
        overrideUserInterfaceStyle: UIUserInterfaceStyle = .unspecified
    ) {
        self.configuration = configuration
        self.preferredBarTintColor = preferredBarTintColor
        self.preferredControlTintColor = preferredControlTintColor
        self.dismissButtonStyle = dismissButtonStyle
        self.modalPresentationStyle = modalPresentationStyle
        self.isModalInPresentation = isModalInPresentation
        self.overrideUserInterfaceStyle = overrideUserInterfaceStyle
    }
    
    func userInterfaceStyle(with colorScheme: ColorScheme) -> UIUserInterfaceStyle {
        switch overrideUserInterfaceStyle {
        case .unspecified:
            return UIUserInterfaceStyle(colorScheme)
        default:
            return overrideUserInterfaceStyle
        }
    }
}

extension SFSafariViewController {
    convenience init(url: URL, configuration: SafariConfiguration) {
        self.init(url: url, configuration: configuration.configuration)
        self.preferredBarTintColor = configuration.preferredBarTintColor
        self.preferredControlTintColor = configuration.preferredControlTintColor
        self.dismissButtonStyle = configuration.dismissButtonStyle
        self.modalPresentationStyle = configuration.modalPresentationStyle
        self.isModalInPresentation = configuration.isModalInPresentation
    }
}

private struct SafariConfigurationKey: EnvironmentKey {
    static let defaultValue: SafariConfiguration? = nil
}

public extension EnvironmentValues {
    var safariConfiguration: SafariConfiguration? {
        get { self[SafariConfigurationKey.self] }
        set { self[SafariConfigurationKey.self] = newValue }
    }
}
#endif
