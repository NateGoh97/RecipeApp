//
//  UserController.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import Foundation

class UserController {
    static let shared = UserController()

    private var user: User?

    func getUser() -> User? {
        return self.user
    }

    func setUser(user: User) {
        self.user = user
        UserDefaultHelper.shared.saveUser(user: user)
    }

    func authenticateUser() {
        self.user = UserDefaultHelper.shared.fetchUser()
    }

    func logout() {
        self.user = nil
        UserDefaultHelper.shared.removeUser()
    }
}
