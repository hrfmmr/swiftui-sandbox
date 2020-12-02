//
//  StatusRow.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import SwiftUI

struct StatusRow: View {
    let viewModel: StatusRowViewModel
    
    init(viewModel: StatusRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: UIImage())
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .background(Color.blue)
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.userName)
                        .font(.headline)
                    Text(viewModel.userScreenName)
                        .font(.caption)
                }
                Text(viewModel.statusText)
                    .font(.body)
            }
        }
    }
}

struct StatusRow_Previews: PreviewProvider {
    static var previews: some View {
        StatusRow(
            viewModel: .init(
                status: .init(
                    id: 1,
                    text: "RT @petrelharp: For the pythonistas: @JosephGuhlin has written a python version of lostruct, for doing local PCA along the genome: https://…",
                    userID: 1,
                    userName: "John Doe",
                    userScreenName: "johndoe", userProfileImageURL: URL(string: "https://pbs.twimg.com/profile_images/1311884223440011266/YRiutPeW_normal.jpg")!
                )
            )
        )
        .previewLayout(.fixed(width: 320, height: 140))
    }
}
