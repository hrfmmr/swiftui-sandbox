//
//  ActivityIndicator.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/04.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var animating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .medium)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        switch animating {
        case true:
            uiView.startAnimating()
        case false:
            uiView.stopAnimating()
        }
    }
}
