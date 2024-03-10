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
public struct SafariConfiguration {
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
    /// The user interface style adopted by the view controller and all of its children.
    public var overrideUserInterfaceStyle: UIUserInterfaceStyle
    
    init() {
        self.configuration = SFSafariViewController.Configuration()
        self.preferredBarTintColor = nil
        self.preferredControlTintColor = .tintColor
        self.dismissButtonStyle = .done
        self.modalPresentationStyle = .automatic
        self.overrideUserInterfaceStyle = .unspecified
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
#endif
