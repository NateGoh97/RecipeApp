//
//  NetworkingController.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingController {
    static let shared = NetworkingController()



    func authenticate(email: String, password: String, isLogin: Bool = true, completion: @escaping(User?, Error?) -> Void) {
        let parameters = ["email": email, "password": password]
        let url = isLogin ? "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA0x3D0xupcNhpIzJIa_C3eDsA9alV5mh0" :"https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA0x3D0xupcNhpIzJIa_C3eDsA9alV5mh0"

        AF.request(url, method: .post,parameters: parameters, encoder: JSONParameterEncoder.default).responseJSON{ response in
            switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        if let _ = JSON["error"] as? [String: Any] {
                            completion(nil, nil)
                            return
                        }
                    }
                if let data = response.data {
                    do {
                        let user: User = try JSONDecoder().decode(User.self, from: data)
                        completion(user, nil)
                    } catch let jsonError {
                        completion(nil, jsonError)
                    }
                }
            case let .failure(error):
                completion(nil, error)
            }

//            if let error = response.error {
//                completion(nil, error)
//                return
//            }
//
//            if let data = response.data {
//                do {
//                    let user: User = try JSONDecoder().decode(User.self, from: data)
//                    completion(user, nil)
//                } catch let jsonError {
//                    completion(nil, jsonError)
//                }
//            }
        }
    }
}
