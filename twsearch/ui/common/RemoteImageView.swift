//
//  RemoteImageView.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/03.
//

import SwiftUI
import Combine

struct RemoteImageView: View {
    @ObservedObject var remoteImage: RemoteImage
    
    var body: some View {
        Image(uiImage: remoteImage.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static let imageURL = URL(string: "https://pbs.twimg.com/profile_images/1311884223440011266/YRiutPeW_normal.jpg")!
    static var previews: some View {
        RemoteImageView(
            remoteImage: RemoteImage(for: imageURL)
        )
        .frame(width: 40, height: 40)
    }
}
