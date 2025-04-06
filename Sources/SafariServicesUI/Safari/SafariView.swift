//
//  SafariView.swift
//  SafariServicesUI
//
//  Created by David Walter on 06.04.25.
//

import SwiftUI
import SafariServices

/// Wrap `SFSafariViewController` in `UIHostingController` to support `isModalInPresentation`
final class SafariHostingController: UIHostingController<SafariView> {
    convenience init(safari: SFSafariViewController) {
        self.init(rootView: SafariView(safari: safari))
    }
}

/// SwiftUI `SFSafariViewController` wrapper
struct SafariView: View {
    let safari: SFSafariViewController

    init(safari: SFSafariViewController) {
        self.safari = safari
    }

    var body: some View {
        SafariRepresentable(safari: safari)
            .ignoresSafeArea()
    }
}

private struct SafariRepresentable: UIViewControllerRepresentable {
    let safari: SFSafariViewController

    init(safari: SFSafariViewController) {
        self.safari = safari
    }

    func makeUIViewController(context: Context) ->SFSafariViewController {
        safari
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
