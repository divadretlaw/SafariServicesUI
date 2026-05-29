//
//  Preview.swift
//  SafariServicesUI
//
//  Created by David Walter on 30.05.26.
//

import SwiftUI

#if DEBUG
struct Preview: View {
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationView {
            List {
                Button {
                    guard let url = URL(string: "https://davidwalter.at") else {
                        return
                    }
                    openURL(url)
                } label: {
                    Text("Show Safari")
                }
            }
            .navigationTitle("Preview")
        }
        .navigationViewStyle(.stack)
    }
}
#endif
