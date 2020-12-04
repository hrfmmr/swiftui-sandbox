//
//  StatusIconImageModifier.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/04.
//

import SwiftUI

struct StatusIconImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        return image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}
