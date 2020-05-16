//
//  MainViewController.swift
//  MemeGenerator
//
//  Created by admin on 2020-05-16.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let ac = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Gallery", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    @objc func saveButtonTapped() {
        
    }
    
    func openPage(action: UIAlertAction) {
        let pickerViewController = UIImagePickerController()
        pickerViewController.sourceType = action.title == "Camera" ? UIImagePickerController.SourceType.camera : UIImagePickerController.SourceType.photoLibrary
        pickerViewController.allowsEditing = true
        pickerViewController.delegate = self
        present(pickerViewController, animated: true, completion: nil)
    }
}

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        imageView.image = image
    }
}
