//
//  View+OnTrigger.swift
//  AuthenticationServicesUI
//
//  Created by David Walter on 06.04.24.
//

import SwiftUI

extension View {
    func onTrigger(of value: Bool, _ action: @escaping () -> Void) -> some View {
        self
            #if os(visionOS)
            .onChange(of: value) { _, value in
                guard value else { return }
                action()
            }
            #else
            .onChange(of: value) { value in
                guard value else { return }
                action()
            }
            #endif
            .onAppear {
                guard value else { return }
                action()
            }
    }
}
