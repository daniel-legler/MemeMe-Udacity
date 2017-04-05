//
//  MemeMakerVC.swift
//  MemeMe
//
//  Created by Daniel Legler on 4/3/17.
//  Copyright © 2017 Daniel Legler. All rights reserved.
//

import UIKit

class MemeMakerVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    

    @IBOutlet weak var pickedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!

    
    // MARK: View Appearance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set UITextField Attributes
        topText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center

        bottomText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        unSubscribeToKeyboardNotifications()
    }
    
    // MARK: UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ["TOP","BOTTOM"].contains(textField.text!) ? "" : textField.text
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: Keyboard Control Methods

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMakerVC.keyboardWillShow(_:)), name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMakerVC.keyboardWillHide(_:)), name: .UIKeyboardWillHide , object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide , object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification){
        if view.frame.origin.y == 0.0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification){
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: UIImagePickerControllerDelegate Methods
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            pickedImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Custom ImagePicker Methods
    
    @IBAction func pickImage(_ sender: Any) {
        setupImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func takeImageWithCamera(_ sender: Any) {
        setupImagePicker(sourceType: .camera)
    }
    
    func setupImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
        
    }
  
    
    
}

