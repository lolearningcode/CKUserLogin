//
//  EntryDetailViewController.swift
//  CKUserLogin
//
//  Created by Lo Howard on 6/6/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var entryImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, let body = bodyTextView.text, !body.isEmpty, let image = entryImageView.image else { return }
        
        EntryController.shared.createNewEntry(title: title, body: body, image: image) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryImageView.image = entry.image
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
}
