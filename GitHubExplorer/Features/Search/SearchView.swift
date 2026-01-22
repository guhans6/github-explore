//
//  ContentView.swift
//  GitHubExplorer
//
//  Created by Guhan on 08/01/26.
//

import SwiftUI

struct SearchView: View {
    
    @State var vm: SearchViewModel
    
    init() {
        _vm = State(initialValue: SearchViewModel())
    }
    
    let gridItem: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch vm.state {
                case .initial:
                    EmptyStateView(imageName: "magnifyingglass", title: "Search Github users")
                case .loading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 30, height: 30)
                case .success(let users):
                    userGridView(users)
                case .error(let error):
                    EmptyStateView(imageName: "magnifyingglass", title: error ?? "No users found")
                }
            }
            .navigationTitle("GitHub Explore")
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
            .searchable(text: $vm.searchText)
            .onChange(of: vm.searchText) {
                vm.onSearchTextChange()
            }
            .task {
//                await viewModel.fetchUserList()
            }
        }
    }
    
    private func userGridView(_ users: [User]) -> some View {
        ScrollView {
            LazyVGrid(columns: gridItem) {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        UserCell(user: user)
                    }
                }
            }
            // Fix for navigation tile glitch
            .padding(.vertical)
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    SearchView()
//        UserCell(userName: "defunkt")
}

struct EmptyStateView: View {
    
    let imageName: String
    let title: String
    let subtitle: String?
    
    init(imageName: String, title: String, subtitle: String? = nil) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .opacity(0.5)
            Text(title)
                .font(.title2)
                .opacity(0.5)
                .padding()
            if let subtitle {
                Text(subtitle)
            }
        }
    }
}
