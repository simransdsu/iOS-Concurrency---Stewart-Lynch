//
//  UserListView.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-25.
//

import SwiftUI

struct UserListView: View {
    
    #warning("Remove the forPreview argument or set it to false before uploading to AppStore")
    @StateObject var vm = UserListViewModel(forPreview: true)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in
                    NavigationLink {
                        PostsListView(userId: user.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
                        }
                    }

                }
            }
            .navigationTitle("Users")
            .listStyle(.plain)
            .onAppear {
//                vm.fetchUsers()
            }
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
