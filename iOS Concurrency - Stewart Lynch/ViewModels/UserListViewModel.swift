//
//  UserListViewModel.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-26.
//

import Foundation

class UserListViewModel: ObservableObject {
    
    @Published var usersAndPosts: [UserAndPosts] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String?
    
    @MainActor
    func fetchUsers() async {
        let apiServiceUsers = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        let apiServicePosts = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        
        do {
            let users: [User] = try await apiServiceUsers.getJSON()
            let posts: [Post] = try await apiServicePosts.getJSON()
            
            for user in users {
                let userPosts = posts.filter { $0.userId == user.id }
                usersAndPosts.append(UserAndPosts(user: user, posts: userPosts))
            }
            
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\n Please contact the developer and provide this error and steps to reproduce"
        }
    }
}

extension UserListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        
        if forPreview {
//            self.users = User.mockUsers
        }
    }
}
