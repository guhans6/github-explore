//
//  RepositoryDetailView.swift
//  GitHubExplorer
//
//  Created by Guhan on 16/01/26.
//

import SwiftUI

struct RepositoryDetailView: View {
    
    @State var vm: RepositoryDetailsViewModel
    @State var test: String = ""
    
    init(user: User, repository: Repository) {
        _vm = State(
            initialValue: RepositoryDetailsViewModel(
                user: user, repository: repository)
        )
    }
    
    var body: some View {
        ZStack{
            Color(.systemGroupedBackground)
                        .ignoresSafeArea()
            VStack {
                VStack(spacing: 15) {
                    HStack(spacing: 30) {
                        AvatarView(urlString: vm.user.avatarURL, size: 100)
                        VStack(alignment: .leading, spacing: 15) {
                            Text(vm.repository.name)
                                .font(.title)
                                .fontWeight(.semibold)
                            Text(vm.user.username)
                                .font(.title2)
                                .foregroundStyle(.cyan)
                        }
                    }
                    .padding()
                    Text(vm.descriptionText)
                        .font(.headline)
                        .fontWeight(.medium)
                        .frame(alignment: .leading)
                        .padding()
                    Divider()
                        .frame(height: 1)
                        .overlay(.tertiary)
                    HStack {
                        FollowTextView(title: "Star", value: vm.repository.stars.formattedCompactString(), iconName: "star.fill")
                        FollowTextView(title: "Fork", value: vm.repository.forks.formattedCompactString(), iconName: "arrow.trianglehead.branch")
                        FollowTextView(title: "Watchers", value: vm.repository.watchers.formattedCompactString(), iconName: "eye.fill")
                    }
                    .padding(.bottom)
                }
                .background(Color(.systemBackground).ignoresSafeArea())
                
                List {
                    LabeledContent("Default Branch:", value: vm.repository.defaultBranch)

                    LabeledContent("Visibility:", value: vm.repository.visibility)
                    LabeledContent("Created:", value: vm.repository.createdAt?.formattedDisplayDate() ?? "-")
                    LabeledContent("Updated:", value: vm.repository.updatedAt?.formattedDisplayDate() ?? "-")
                }
                .fontWeight(.medium)
                
//            MARK: ALETERNATIVE
//                ZStack {
//                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 0) {
//                        Group {
//                            RepositoryInfoView(field: "Language", value: vm.repository.language ?? "-")
//                            Divider()
//                            RepositoryInfoView(field: "Default Branch:", value: vm.repository.defaultBranch)
//                            RepositoryInfoView(field: "Visibility:", value: vm.repository.visibility)
//                            RepositoryInfoView(field: "Created:", value: vm.repository.createdAt?.formattedDisplayDate() ?? "-")
//                            RepositoryInfoView(field: "Updated:", value: vm.repository.updatedAt?.formattedDisplayDate() ?? "-")
//                        }
//                        .padding(.vertical, 5)
//                    }
//                    .fixedSize(horizontal: true, vertical: false)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                }
//                .background {
//                    RoundedRectangle(cornerRadius: 10)
//                        .foregroundStyle(.background)
//                }
//                .padding(.vertical, 10)
//                .padding(.horizontal)
//                Spacer()
            }
        }
    }
}

#Preview {
    RepositoryDetailView(user: MockData.user, repository: MockData.repo)
}


//MARK: THIS IS ANOTHER WAY TO ACHIVED SYNCHRONIZED LABEL WIDTH ACROSS A LIST OF DATA USING GRID AND GRID ROW
struct RepositoryInfoView: View {
    
    let field: String
    let value: String
    
    var body: some View {
        GridRow {
            Text(field)
                .fontWeight(.medium)
            Text(value)
        }
    }
}

