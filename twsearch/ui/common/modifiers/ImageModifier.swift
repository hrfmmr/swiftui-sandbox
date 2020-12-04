//
//  ImageModifier.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/04.
//

import SwiftUI

protocol ImageModifier {
    associatedtype Body: View
    func body(image: Image) -> Self.Body
}

extension Image {
    func modifier<M>(_ imgmodifier: M) -> some View where M: ImageModifier {
        imgmodifier.body(image: self)
    }
}
