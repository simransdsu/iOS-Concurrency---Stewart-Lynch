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
    
    func fetchUsers() {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        isLoading.toggle()
        apiService.getJSON { (result: Result<[User], APIError>) in
            
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.users = success
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

extension UserListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        
        if forPreview {
            self.users = User.mockUsers
        }
    }
}
