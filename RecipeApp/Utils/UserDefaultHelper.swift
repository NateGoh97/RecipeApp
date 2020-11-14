//
//  UserDefaultHelper.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import Foundation

class UserDefaultHelper {
    static let shared = UserDefaultHelper()

    func saveUser(user: User) {
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.idToken, forKey: "idToken")
    }

    func removeUser() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "idToken")
    }

    func fetchUser() ->  User? {
        let email = UserDefaults.standard.string(forKey: "email")
        let idToken = UserDefaults.standard.string(forKey: "idToken")

        if email == nil || idToken == nil {
            return nil
        }

        let user = User(email: email, idToken: idToken)

        return user
    }
}
