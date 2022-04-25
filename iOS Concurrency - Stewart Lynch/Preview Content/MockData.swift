//
//  MockData.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-26.
//

import Foundation

extension User {
    
    static var mockUsers: [User] {
        Bundle.main.decode([User].self, from: "users.json")
    }
    
    static var mockSingleUser: User {
        Self.mockUsers[0]
    }
}


extension Post {
    
    static var mockPosts: [Post] {
        Bundle.main.decode([Post].self , from: "posts.json")
    }
    
    static var mockSinglePost: Post {
        Self.mockPosts[0]
    }
    
    static var mockSingleUsersPostArray: [Post] {
        Self.mockPosts.filter { $0.userId == 1}
    }
}
