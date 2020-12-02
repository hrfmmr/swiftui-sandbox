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
        List {
            searchTextField
            if viewModel.dataSource.isEmpty {
                emptySection
            } else {
                statusesSection
            }
        }
    }
}

private extension SearchStatusesView {
    var searchTextField: some View {
        TextField("e.g. Covid-19", text: $viewModel.query)
    }
    
    var emptySection: some View {
        Section {
            Text("No Results")
                .foregroundColor(.gray)
        }
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
