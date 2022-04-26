//
//  UserListViewModel.swift
//  iOS Concurrency - Stewart Lynch
//
//  Created by Simran Preet Singh Narang on 2022-04-26.
//

import Foundation

class UserListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String?
    
    @MainActor
    func fetchUsers() async {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading.toggle()
        defer {
            isLoading.toggle()
        }
        
        do {
            users = try await apiService.getJSON()
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
            self.users = User.mockUsers
        }
    }
}
