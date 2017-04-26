//
//  Task1VC.swift
//  CleverDiner
//
//  Created by admin on 4/25/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class Task1VC: UIViewController, UITextFieldDelegate {
    
    var profileImageUrl: String?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.gray
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "profileImage")
        return imageView
    }()
    
    let editImageBtn: UIButton = {
        let editBtn = UIButton()
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        editBtn.backgroundColor = UIColor.white
        editBtn.layer.masksToBounds = true
        editBtn.contentMode = .scaleAspectFill
        editBtn.setImage(UIImage(named: "editIcon"), for: .normal)
        return editBtn
    }()
    
    let dealName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Deal Title:   "
        return label
    }()
    let dealNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Deal Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let startDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Start Date:   "
        return label
    }()
    let startDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Start Date"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let endDataName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "End Date:   "
        return label
    }()
    let endDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "End Date"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let discountPercentage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Discount Percentage: "
        return label
    }()
    let discountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter percentage off (%)"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let location: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Location: "
        return label
    }()
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "City or Town"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let profileInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Deal Details: "
        return label
    }()
    let profileInfoTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Describe the discount or deal?"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let containerView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.masksToBounds = true
        container.backgroundColor = UIColor.white
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveButton))
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImageView)))
        editImageBtn.addTarget(self, action: #selector(selectProfileImageView), for: .touchUpInside)
        
        // Grab current profile info
        getUserDetails()
        
        dealNameTextField.delegate = self
        discountTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        locationTextField.delegate = self
        profileInfoTextField.delegate = self
        
        setupProfileViews()
        
        setupKeyboardObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserDetails()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func handleKeyboardWillShow (notifcation: NSNotification) {
        let keyboardFrame = (notifcation.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notifcation.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewTopAnchor?.constant = -keyboardFrame!.height + 104
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewTopAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    func getUserDetails() {
        
        let saveDetails = ProfileDetails.sharedInstance.getProfileDetails()
        
        if let userName     = saveDetails?["userName"]  as? String { self.dealNameTextField.text = userName }
        if let firstName    = saveDetails?["firstName"]  as? String { self.startDateTextField.text = firstName }
        if let lastName     = saveDetails?["lastName"]   as? String { self.endDateTextField.text = lastName }
        if let gender       = saveDetails?["gender"]     as? String { self.discountTextField.text = gender }
        if let loc          = saveDetails?["location"]   as? String { self.locationTextField.text = loc }
        if let details      = saveDetails?["details"]    as? String { self.profileInfoTextField.text = details }
        if let imgUrl       = saveDetails?["imageUrl"]   as? String {
            //           self.profileImageView.loadImageUsingCacheWithUrlString(urlString: imgUrl)
        }
    }
    
    func cancelButton() {
        navigationController?.popViewController(animated: true)
    }
    func saveButton() {
        updatedProfileText(fieldToUpdate: "imageUrl", newInfo: self.profileImageUrl)
        updatedProfileText(fieldToUpdate: "userName", newInfo: dealNameTextField.text)
        updatedProfileText(fieldToUpdate: "firstName", newInfo: startDateTextField.text)
        updatedProfileText(fieldToUpdate: "lastName", newInfo: endDateTextField.text)
        updatedProfileText(fieldToUpdate: "location", newInfo: locationTextField.text)
        updatedProfileText(fieldToUpdate: "gender", newInfo: discountTextField.text)
        updatedProfileText(fieldToUpdate: "details", newInfo: profileInfoTextField.text)
        navigationController?.popViewController(animated: true)
    }
    
    func updatedProfileText(fieldToUpdate: String, newInfo: String?) {
        
        var profileDetailsDic = ProfileDetails.sharedInstance.getProfileDetails()
        
        if let user = profileDetailsDic?[fieldToUpdate] as? String {
            if user != newInfo {
                profileDetailsDic?.updateValue(newInfo!, forKey: fieldToUpdate)
                ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: profileDetailsDic!)
            }
        }
    }
    
    var containerViewTopAnchor: NSLayoutConstraint?
    
    func setupProfileViews() {
        
        view.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(editImageBtn)
        containerView.addSubview(dealName)
        containerView.addSubview(dealNameTextField)
        containerView.addSubview(startDate)
        containerView.addSubview(startDateTextField)
        containerView.addSubview(endDataName)
        containerView.addSubview(endDateTextField)
        containerView.addSubview(location)
        containerView.addSubview(locationTextField)
        containerView.addSubview(discountPercentage)
        containerView.addSubview(discountTextField)
        containerView.addSubview(profileInfo)
        containerView.addSubview(profileInfoTextField)
        
        containerViewTopAnchor = containerView.topAnchor.constraint(equalTo: view.topAnchor)
        containerViewTopAnchor?.isActive = true
        
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 70).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
        editImageBtn.rightAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        editImageBtn.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10).isActive = true
        editImageBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        editImageBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        dealName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dealName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        dealName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        dealName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        dealNameTextField.leftAnchor.constraint(equalTo: dealName.rightAnchor, constant: 10).isActive = true
        dealNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        dealNameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        dealNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        startDate.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        startDate.topAnchor.constraint(equalTo: dealName.bottomAnchor, constant: 5).isActive = true
        startDate.widthAnchor.constraint(equalToConstant: 120).isActive = true
        startDate.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        startDateTextField.leftAnchor.constraint(equalTo: startDate.rightAnchor, constant: 10).isActive = true
        startDateTextField.topAnchor.constraint(equalTo: dealName.bottomAnchor, constant: 5).isActive = true
        startDateTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        startDateTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        endDataName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        endDataName.topAnchor.constraint(equalTo: startDate.bottomAnchor, constant: 5).isActive = true
        endDataName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        endDataName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        endDateTextField.leftAnchor.constraint(equalTo: endDataName.rightAnchor, constant: 10).isActive = true
        endDateTextField.topAnchor.constraint(equalTo: endDataName.topAnchor).isActive = true
        endDateTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        endDateTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        location.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        location.topAnchor.constraint(equalTo: endDataName.bottomAnchor, constant: 5).isActive = true
        location.widthAnchor.constraint(equalToConstant: 120).isActive = true
        location.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        locationTextField.leftAnchor.constraint(equalTo: location.rightAnchor, constant: 10).isActive = true
        locationTextField.topAnchor.constraint(equalTo: location.topAnchor).isActive = true
        locationTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        discountPercentage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        discountPercentage.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 5).isActive = true
        discountPercentage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        discountPercentage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        discountTextField.leftAnchor.constraint(equalTo: discountPercentage.rightAnchor, constant: 10).isActive = true
        discountTextField.topAnchor.constraint(equalTo: discountPercentage.topAnchor).isActive = true
        discountTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        discountTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        profileInfo.topAnchor.constraint(equalTo: discountPercentage.bottomAnchor, constant: 5).isActive = true
        profileInfo.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileInfo.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileInfoTextField.leftAnchor.constraint(equalTo: profileInfo.rightAnchor, constant: 10).isActive = true
        profileInfoTextField.topAnchor.constraint(equalTo: profileInfo.topAnchor).isActive = true
        profileInfoTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profileInfoTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dealNameTextField.resignFirstResponder()
        discountTextField.resignFirstResponder()
        startDateTextField.resignFirstResponder()
        endDateTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        profileInfoTextField.resignFirstResponder()
    }
}
extension Task1VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selectProfileImageView() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
}
