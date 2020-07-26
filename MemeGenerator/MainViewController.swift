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
    let controlPanelView = UIView()
    let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavBar()
        setupImageView()
        setupDragRecognizer()
    }

    fileprivate func setupBackground() {
        view.backgroundColor = .white
    }
    
    fileprivate func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    fileprivate func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    fileprivate func setupDragRecognizer() {
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(userDragged(gesture:)))
        textView.addGestureRecognizer(gesture)
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.text = "testing"
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 20)
        textView.center = view.center
        textView.sizeToFit()
        textView.textContainer.heightTracksTextView = true
        view.addSubview(textView)
    }
    
    @objc func userDragged(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: view)
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
        let ac = UIAlertController(title: "Save Photo?", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: savePhoto))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let pickerViewController = UIImagePickerController()
        pickerViewController.sourceType = action.title == "Camera" && UIImagePickerController.isSourceTypeAvailable(.camera) ? UIImagePickerController.SourceType.camera : UIImagePickerController.SourceType.photoLibrary
        pickerViewController.allowsEditing = true
        pickerViewController.delegate = self
        present(pickerViewController, animated: true, completion: nil)
    }
    
    func savePhoto(action: UIAlertAction) {
        
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

extension MainViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedHeight = textView.frame.size.height
        let newSize = textView.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: fixedHeight))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: newSize.width, height: max(newSize.height, fixedHeight))
        textView.frame = newFrame
    }
}
