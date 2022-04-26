//
//  UserAndPosts.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-26.
//

import Foundation

struct UserAndPosts: Identifiable {
    
    var id = UUID()
    var user: User
    var posts: [Post]
    var numberOfPosts: Int {
        return posts.count
    }
}
