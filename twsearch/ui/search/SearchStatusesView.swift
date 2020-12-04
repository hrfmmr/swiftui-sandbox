//
//  SearchStatusesView.swift
//  twsearch
//
//  Created by hrfm mr on 2020/12/02.
//

import SwiftUI
import Combine

struct SearchStatusesView: View {
    @ObservedObject var viewModel: SearchStatusesViewModel
    
    init(viewModel: SearchStatusesViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            searchTextField
            if viewModel.shouldShowLoading {
                Spacer()
                Text("Loading...")
                Spacer()
            } else if viewModel.dataSource.isEmpty {
                Spacer()
                emptySection
                Spacer()
            } else {
                List {
                    statusesSection
                }
            }
        }
    }
}

private extension SearchStatusesView {
    var searchTextField: some View {
        TextField("Search", text: $viewModel.query)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(6)
            .padding(.horizontal, 10)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    if viewModel.isEditing {
                        Button(action: {
                            viewModel.clearSearchText()
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 15)
                        }
                    }
                }
            )
    }
    
    var emptySection: some View {
        Text("No Results")
            .foregroundColor(.gray)
    }
    
    var statusesSection: some View {
        ForEach(viewModel.dataSource, content: StatusRow.init(viewModel:))
    }
}

struct SearchStatusesView_Previews: PreviewProvider {
    static var previews: some View {
        SearchStatusesView(
            viewModel: SearchStatusesViewModel(
                dependency: (
                    TwitterAPIClient.shared,
                    DispatchQueue.init(label: "SearchStatusesViewModel")
                )
            )
        )
    }
}
