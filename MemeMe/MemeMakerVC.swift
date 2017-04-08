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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var activeTextField: UITextField!
    var meme: Meme!
    
    // MARK: View Appearance Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [topText, bottomText].forEach { formatTextField(named: $0) }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        shareButton.isEnabled = pickedImageView.image == nil ? false : true
        
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(true)
        
        unSubscribeToKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: UITextField Delegate Methods
    
    func formatTextField(named textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
        
        textField.text = ["TOP","BOTTOM"].contains(textField.text!) ? "" : textField.text
    
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        activeTextField = nil
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
        
        let keyboardHeight = getKeyboardHeight(notification)
        
        // Only move view up if the keyboard will cover the active text field
        if let activeField = self.activeTextField {
            var aRect: CGRect = self.view.frame
            aRect.size.height -= keyboardHeight
            if !aRect.contains(activeField.frame.origin) {
                view.frame.origin.y -= keyboardHeight
            }
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
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        dismiss(animated: true	)
    }
    
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
    
    // MARK: Image Sharing Methods
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        let memeImage: UIImage = generateMemedImage()
        
        let imageToShare = [memeImage]
        
        let activityView = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityView.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            
            if completed {

                let meme = Meme(top: self.topText.text!, bottom: self.bottomText.text!, originalImage: self.pickedImageView.image!, memeImage: memeImage)
                
                ad.memes.append(meme)

                self.dismiss(animated: true, completion: nil)
            }
        }
        
        self.present(activityView, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        updateBarVisibility()

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        updateBarVisibility()
        
        return memedImage
    }
    
    func updateBarVisibility() {
        self.navigationController?.navigationBar.isHidden = !(self.navigationController?.navigationBar.isHidden)!
        self.topToolbar.isHidden = !self.topToolbar.isHidden
        self.bottomToolbar.isHidden = !self.bottomToolbar.isHidden
    }
    
    
}

