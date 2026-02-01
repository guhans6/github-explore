//
//  ContentView.swift
//  GitHubExplorer
//
//  Created by Guhan on 08/01/26.
//

import SwiftUI

struct SearchView: View {
    
    @State var vm: SearchViewModel
    @State var columnVisibility = NavigationSplitViewVisibility.all
    
    init() {
        _vm = State(initialValue: SearchViewModel())
    }
    
    let gridItem: [GridItem] = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
    ]
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
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
                    //iOS SDK Provided
                    ContentUnavailableView(error, systemImage: "exclamationmark.triangle")
                case .emptyResult:
                    ContentUnavailableView("No users found", systemImage: "person.slash")
                }
            }
            .navigationTitle("GitHub Explore")
            .searchable(text: $vm.searchText)
            .onChange(of: vm.searchText) {
                vm.onSearchTextChange()
            }
            //MARK: .task with id has automatic cancellation
//            .task(id: vm.searchText) {
//                await vm.onSearchTextChange()
//            }
//            .task {
//                await viewModel.fetchUserList()
//            }
        } detail: {
            if let selectedUser = vm.selectedUser {
                NavigationStack {
                    ProfileView(user: selectedUser)
                }
            } else {
                ContentUnavailableView("Select a user", systemImage: "person.crop.circle")
            }
        }

//        NavigationStack {
//            ZStack {
//                switch vm.state {
//                case .initial:
//                    EmptyStateView(imageName: "magnifyingglass", title: "Search Github users")
//                case .loading:
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                        .frame(width: 30, height: 30)
//                case .success(let users):
//                    userGridView(users)
//                case .error(let error):
//                    EmptyStateView(imageName: "magnifyingglass", title: error ?? "No users found")
//                }
//            }
//            .navigationTitle("GitHub Explore")
//            .navigationDestination(for: User.self, destination: { user in
//                ProfileView(user: user)
//            })
//            .searchable(text: $vm.searchText)
//            .onChange(of: vm.searchText) {
//                vm.onSearchTextChange()
//            }
//            .task {
//                await viewModel.fetchUserList()
//            }
//        }
    }
    
    private func userGridView(_ users: [User]) -> some View {
        ScrollView {
            LazyVGrid(columns: gridItem) {
                ForEach(users) { user in
//                    NavigationLink(value: user) {
//                        UserCell(user: user)
//                    }
                    UserCell(user: user)
                        .onTapGesture {
                            vm.selectedUser = user
//                            if UIDevice.current.userInterfaceIdiom == .pad {
//                                columnVisibility = .detailOnly
//                            }
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
                .frame(width: 70, height: 70)
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
