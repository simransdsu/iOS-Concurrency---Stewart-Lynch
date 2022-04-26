//
//  PostsListViewModel.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-26.
//

import Foundation

class PostsListViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String?
    
    var userId: Int?
    
    func fetchPosts() {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/user/\(userId)/posts")
            isLoading.toggle()
            apiService.getJSON { (result: Result<[Post], APIError>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading.toggle()
                    }
                }
                
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        self.posts = success
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        print("❌", failure)
                        self.showAlert = true
                        self.errorMessage = failure.localizedDescription + "\n Please contact the developer and provide this error and steps to reproduce"
                    }
                }
            }
        }
    }
}


extension PostsListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        
        if forPreview {
            self.posts = Post.mockSingleUsersPostArray
        }
    }
}
