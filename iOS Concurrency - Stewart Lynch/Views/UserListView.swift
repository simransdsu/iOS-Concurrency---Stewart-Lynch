//
//  UserListView.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-25.
//

import SwiftUI

struct UserListView: View {
    
    #warning("Remove the forPreview argument or set it to false before uploading to AppStore")
    @StateObject var vm = UserListViewModel(forPreview: false)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.usersAndPosts) { userAndPosts in
                    NavigationLink {
                        PostsListView(posts: userAndPosts.posts)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(userAndPosts.user.name)
                                    .font(.title)
                                Spacer()
                                Text("(\(userAndPosts.numberOfPosts))")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            Text(userAndPosts.user.email)
                        }
                    }

                }
            }
            .overlay(content: {
                if vm.isLoading {
                    ProgressView()
                }
            })
            .alert("Application Error", isPresented: $vm.showAlert, actions: {
                Button("OK") {}
            }, message: {
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                }
            })
            .navigationTitle("Users")
            .listStyle(.plain)
            .task {
                await vm.fetchUsers()
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
