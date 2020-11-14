//
//  AuthViewController.swift
//  RecipeApp
//
//  Created by Nate Goh on 14/11/2020.
//  Copyright © 2020 Nate Goh. All rights reserved.
//

import UIKit

enum AuthStatus {
    case login, signUp
}

class AuthViewController: UIViewController {

    private var authStatus: AuthStatus = .login

    @IBOutlet private weak var usernameTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var authButton: UIButton!
    @IBOutlet private weak var switchActionLabel: UILabel!
    @IBOutlet private weak var switchActionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initCommon()
    }

    private func initCommon() {
        authButton.setTitleColor(.white, for: .normal)
        authButton.layer.cornerRadius = 12
        authButton.backgroundColor = .orange

        passwordTextfield.isSecureTextEntry = true

        updateView()
    }

    private func updateView() {
        authButton.setTitle(authStatus == .login ? "Sign In" : "Sign Up", for: .normal)
        switchActionLabel.text = authStatus == .login ? "Don't have an account? Sign Up" : "Already have an account? Sign In"
    }
}

extension AuthViewController {
    @IBAction func authButtonWasTapped(_ sender: UIButton) {
         guard let username = usernameTextfield.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextfield.text?.trimmingCharacters(in: .whitespaces) else { return }
        validateInput(username: username, password: password)


        NetworkingController.shared.authenticate(email: username, password: password, isLogin: authStatus == .login ? true : false) { (user, error) in
            if user == nil && error == nil {
                self.displayErrorDialog(error: self.authStatus == .login ? "Either password or email is incorrect, please try again." : "Something went wrong, please try again.")
                return
            }

            if let error = error {
                self.displayErrorDialog(error: error.localizedDescription)
                return
            }
            if let user = user {
                UserController.shared.setUser(user: user)
            }
            let vc = UINavigationController(rootViewController: RecipeViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }

    }

    @IBAction func switchActionButtonWasTapped(_ sender: UIButton) {
        switch authStatus {
        case .login:
            authStatus = .signUp
        case .signUp:
            authStatus = .login
        }
        resetTextField()
        updateView()
    }
}

extension AuthViewController {
    private func validateInput(username: String, password: String) {
        if username.isEmpty || password.isEmpty {
            displayErrorDialog(error: "Username and password is required!")
            return
        }
        if password.count < 6 {
            displayErrorDialog(error: "Password must be 6 character long")
            return
        }
        if !isValidEmail(username) {
            displayErrorDialog(error: "Please enter a valid email addres")
            return
        }
    }

    private func resetTextField() {
        usernameTextfield.text = ""
        passwordTextfield.text = ""
    }

    private func displayErrorDialog(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let pred = NSPredicate(format:"SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }
}
