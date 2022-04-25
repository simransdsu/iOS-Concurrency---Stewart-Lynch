//
//  PostsListViewModel.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-26.
//

import Foundation

class PostsListViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    
    var userId: Int?
    
    func fetchPosts() {
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/user/\(userId)/posts")
            apiService.getJSON { (result: Result<[Post], APIError>) in
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        self.posts = success
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        print("❌", failure)
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
