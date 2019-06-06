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
                    self.performSegue(withIdentifier: "toWelcomeVCFrom", sender: nil)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
