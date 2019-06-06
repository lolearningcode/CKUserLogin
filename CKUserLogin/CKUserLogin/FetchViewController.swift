//
//  FetchViewController.swift
//  CKUserLogin
//
//  Created by Lo Howard on 6/5/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class FetchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserController.shared.fetchCurrentUser { (success) in
            if success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "navController")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                }
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
                }
            }
        }
    }
}

