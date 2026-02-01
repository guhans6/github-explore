//
//  ProfileView.swift
//  GitHubExplorer
//
//  Created by Guhan on 11/01/26.
//

import SwiftUI

struct ProfileView: View {
    
    let user: User
    @State private var vm: ProfileViewModel = ProfileViewModel()
    @Environment(\.openURL) private var openURL
    
    enum ProfileRoute: Hashable {
        case repositoryList
    }
    
    var body: some View {
        ZStack {
            VStack {
                //MARK: WHAT SHOULD BE THE HANDLING? SHOW USER DATA WE HAVE AND USER SEPERATE LOADING FOR BELOW?
                //MARK: OR SHOW LOADING FULLY FOR PAGE AND ONLY SHOW USERDETAIL MODEL?
                AvatarView(urlString: user.avatarURL, size: 120)
//                    .id(user.id)  //This redraws the whole view if id changes
                Text(user.username)
                    .font(.title3)
                    .padding(.top)
                switch vm.profileState {
                case .initial, .loading:
                    ProgressView()
                        .progressViewStyle(.circular)
                        .padding(.top)
                case .success(let userDetail):
                    if let bio = userDetail.bio {
                        Text(bio)
                            .font(.title3)
                            .padding()
                    }
                    FollowStatsView(followers: userDetail.followers.formattedCompactString(), following: userDetail.following.formattedCompactString(), repositories: userDetail.publicRepos.formattedCompactString())
                        .frame(width: 250)
                case .error(let errorString):
                    ContentUnavailableView(errorString, systemImage: "exclamationmark.triangle")
                }
            }
            .padding(.bottom, 100)
            VStack(spacing: 20) {
                Spacer()
                NavigationLink(value: ProfileRoute.repositoryList) {
                    ExplorerButtonLabel(text: "View Repositories", systemImage: "list.dash")
                }
                .disabled(vm.isProfileLoading)
                .frame(width: 300)
                .tint(.green)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .controlSize(.large)
                Link(destination: APIConfig.githubBaseURL.appending(path: user.username)) {
                    ExplorerButtonLabel(text: "View Full Profile", systemImage: "person.and.background.striped.horizontal")
                }
//                Button {
//                    let url = APIConfig.githubBaseURL.appending(path: vm.user.username)
//                    openURL(url)
//                } label: {
//                    ExplorerButtonLabel(text: "View Full Profile", systemImage: "person.and.background.striped.horizontal")
//                }
                .frame(width: 300)
                .padding(.bottom, 50)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .controlSize(.large)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: ProfileRoute.self, destination: { route in
            switch route {
            case .repositoryList:
                RepositoriesView(user: user)
            }
        })
        //With this we can just update the data instead of redrawing the while view
        .task(id: user.id) {
            await vm.fetchUserDetails(for: user)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(user: MockData.user)
    }
}


struct FollowStatsView: View {
    
    let followers: String
    let following: String
    let repositories: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.fill)
            
            HStack {
                FollowTextView(title: "Followers", value: followers)
                    .frame(width: 110,alignment: .center)
                Divider()
                    .frame(width: 1)
                    .overlay(.secondary)
                    .padding(.vertical, 10)
                FollowTextView(title: "Following", value: following)
                    .frame(width: 110,alignment: .center)
                Divider()
                    .frame(width: 1)
                    .overlay(.secondary)
                    .padding(.vertical, 10)
                FollowTextView(title: "Repos", value: repositories)
                    .frame(width: 110,alignment: .center)
            }
        }
        .frame(height: 60)
//        .padding(.horizontal, 10)
    }
}

struct FollowTextView: View {
    
    let title: String
    let value: String
    let iconName: String?
    
    var valueFont: Font = .subheadline
    var valueWeight: Font.Weight = .semibold
    var titleColor: Color = Color(uiColor: .label)
    
    init(title: String, value: String, iconName: String? = nil) {
        self.title = title
        self.value = value
        self.iconName = iconName
    }
    
    var body: some View {
        VStack {
            Text("\(value)")
                .font(valueFont)
                .fontWeight(valueWeight)
                .foregroundStyle(titleColor)
                .padding(.top, 5)
            Group {
                if let iconName {
                    Label(title, systemImage: iconName)
                } else {
                    Text("\(title)")
                }
            }
            .font(.body)
            .foregroundStyle(titleColor)
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity)
    }
}


struct ExplorerButtonLabel: View {
    
    let text: String
    let systemImage: String
    
    var body: some View {
        HStack( spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 24)
            Text(text)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
    }
}
