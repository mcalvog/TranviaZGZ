//
//  View+Hidden.swift
//  TranviaZGZ
//
//  Created by Marcos on 2/12/21.
//  Adapted from: https://stackoverflow.com/a/59228385
//

import SwiftUI

extension View {
    
    @ViewBuilder func isHidden(_ hidden: Binding<Bool>) -> some View {
        if hidden.wrappedValue {
            self.hidden()
        } else {
            self
        }
    }
    
    @ViewBuilder func isVisible(_ visible: Binding<Bool>) -> some View {
        if visible.wrappedValue {
            self
        } else {
            self.hidden()
        }
    }
    
}
