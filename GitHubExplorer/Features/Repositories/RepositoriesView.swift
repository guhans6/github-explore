//
//  RepositoriesView.swift
//  GitHubExplorer
//
//  Created by Guhan on 16/01/26.
//

import SwiftUI

struct RepositoriesView: View {
    
    @State var viewModel: RepositoriesViewModel
    
    init(user: User) {
        _viewModel = State(initialValue: RepositoriesViewModel(user: user))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.large)
            } else {
                List(viewModel.repositories) { repository in
                    NavigationLink(value: repository) {
                        RepoListCell(name: repository.name, description: repository.description, stars: viewModel.starsText(for: repository))
                            .frame(minHeight: 40)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Repos")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Repository.self, destination: { repository in
            RepositoryDetailView(user: viewModel.user, repository: repository)
        })
        .task {
            await viewModel.fetchRepositories()
        }
        .refreshable {
            await viewModel.fetchRepositories()
        }
    }
}

#Preview {
    NavigationStack {
        RepositoriesView(user: MockData.user)
    }
}

#Preview {
    RepoListCell(name: "open-llm", description: "GUI to all open source LLM models", stars: "1433")
}

struct RepoListCell: View {
    
    let name: String
    let description: String?
    let stars: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title3)
                if let description = description {
                    Text(description)
                        .font(.subheadline)
                        .lineLimit(2)
                        .padding(.vertical, 1)
                } else {
                }
            }
            .padding(.trailing, 10)
            Spacer()
            ZStack {
                HStack(spacing: 0) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .imageScale(.small)
//                        .padding(.leading, 1)
                        .padding(.trailing, 3)
                    Divider()
                        .overlay(.tertiary)
                        .frame(width: 1,height: 25)
                        .padding(.trailing, 6)
                    Text(String(stars))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(width: 35, alignment: .leading)
                }
                .padding(.horizontal, 5)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.tertiary.opacity(0.3))
                    .frame(height: 30)
            }
        }
    }
}
