//
//  SignUpViewController.swift
//  CKUserLogin
//
//  Created by Lo Howard on 6/5/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty, let firstName = firstNameTextField.text, !firstName.isEmpty else { return }
        
        UserController.shared.createNewUser(username: username, firstName: firstName) { (success) in
            if success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "navController")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                }
            }
        }
    }
}
