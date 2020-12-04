//
//  RemoteImageView.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/03.
//

import SwiftUI
import Combine

struct RemoteImageView<M: ImageModifier>: View {
    @ObservedObject var remoteImage: RemoteImage
    let imageModifier: M
    
    init(remoteImage: RemoteImage, imageModifier: M) {
        self.remoteImage = remoteImage
        self.imageModifier = imageModifier
    }
    
    var body: some View {
        Image(uiImage: remoteImage.image)
            .modifier(imageModifier)
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static let imageURL = URL(string: "https://pbs.twimg.com/profile_images/1311884223440011266/YRiutPeW_normal.jpg")!
    static var previews: some View {
        RemoteImageView(
            remoteImage: RemoteImage(for: imageURL),
            imageModifier: StatusIconImageModifier()
        )
    }
}
