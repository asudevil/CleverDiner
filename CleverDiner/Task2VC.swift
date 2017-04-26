//
//  Task2VC.swift
//  CleverDiner
//
//  Created by admin on 4/25/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class Task2VC: UIViewController, UITextFieldDelegate {
    
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
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Company Name:   "
        return label
    }()
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Company Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let firstName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Manager First Name:   "
        return label
    }()
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let lastName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Manager Last Name:   "
        return label
    }()
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    let restaurantType: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Restaurant Type: "
        return label
    }()
    let typeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type of restaurant"
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
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Business Email:"
        return label
    }()
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Business Email Address"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Business Phone:"
        return label
    }()
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "000-000-0000"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let ethinicity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Ethnicity:"
        return label
    }()
    let occupationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Ethnicity"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let profileInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.text = "Detail description: "
        return label
    }()
    let profileInfoTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Describe restaurant in 200 words or less?"
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
        
        usernameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        typeTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        locationTextField.delegate = self
        occupationTextField.delegate = self
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
        
        if let email        = saveDetails?["email"]      as? String { self.emailTextField.text = email }
        if let userName     = saveDetails?["userName"]  as? String { self.usernameTextField.text = userName }
        if let firstName    = saveDetails?["firstName"]  as? String { self.firstNameTextField.text = firstName }
        if let lastName     = saveDetails?["lastName"]   as? String { self.lastNameTextField.text = lastName }
        if let gender       = saveDetails?["gender"]     as? String { self.typeTextField.text = gender }
        if let loc          = saveDetails?["location"]   as? String { self.locationTextField.text = loc }
        if let phone        = saveDetails?["phone"]      as? String { self.phoneTextField.text = phone }
        if let title        = saveDetails?["occupation"] as? String { self.occupationTextField.text = title }
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
        updatedProfileText(fieldToUpdate: "userName", newInfo: usernameTextField.text)
        updatedProfileText(fieldToUpdate: "firstName", newInfo: firstNameTextField.text)
        updatedProfileText(fieldToUpdate: "lastName", newInfo: lastNameTextField.text)
        updatedProfileText(fieldToUpdate: "location", newInfo: locationTextField.text)
        updatedProfileText(fieldToUpdate: "email", newInfo: emailTextField.text)
        updatedProfileText(fieldToUpdate: "phone", newInfo: phoneTextField.text)
        updatedProfileText(fieldToUpdate: "gender", newInfo: typeTextField.text)
        updatedProfileText(fieldToUpdate: "occupation", newInfo: occupationTextField.text)
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
        containerView.addSubview(userName)
        containerView.addSubview(usernameTextField)
        containerView.addSubview(firstName)
        containerView.addSubview(firstNameTextField)
        containerView.addSubview(lastName)
        containerView.addSubview(lastNameTextField)
        containerView.addSubview(location)
        containerView.addSubview(locationTextField)
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(phoneLabel)
        containerView.addSubview(phoneTextField)
        containerView.addSubview(restaurantType)
        containerView.addSubview(typeTextField)
        containerView.addSubview(ethinicity)
        containerView.addSubview(occupationTextField)
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
        
        userName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        userName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        userName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        usernameTextField.leftAnchor.constraint(equalTo: userName.rightAnchor, constant: 10).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        firstName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        firstName.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5).isActive = true
        firstName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        firstName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        firstNameTextField.leftAnchor.constraint(equalTo: firstName.rightAnchor, constant: 10).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 5).isActive = true
        firstNameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        lastName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 5).isActive = true
        lastName.widthAnchor.constraint(equalToConstant: 120).isActive = true
        lastName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        lastNameTextField.leftAnchor.constraint(equalTo: lastName.rightAnchor, constant: 10).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: lastName.topAnchor).isActive = true
        lastNameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        location.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        location.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 5).isActive = true
        location.widthAnchor.constraint(equalToConstant: 120).isActive = true
        location.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        locationTextField.leftAnchor.constraint(equalTo: location.rightAnchor, constant: 10).isActive = true
        locationTextField.topAnchor.constraint(equalTo: location.topAnchor).isActive = true
        locationTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        locationTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        emailLabel.topAnchor.constraint(equalTo: location.bottomAnchor, constant: 5).isActive = true
        emailLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 10).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailLabel.topAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        phoneLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5).isActive = true
        phoneLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        phoneTextField.leftAnchor.constraint(equalTo: phoneLabel.rightAnchor, constant: 10).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: phoneLabel.topAnchor).isActive = true
        phoneTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        restaurantType.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        restaurantType.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5).isActive = true
        restaurantType.widthAnchor.constraint(equalToConstant: 120).isActive = true
        restaurantType.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        typeTextField.leftAnchor.constraint(equalTo: restaurantType.rightAnchor, constant: 10).isActive = true
        typeTextField.topAnchor.constraint(equalTo: restaurantType.topAnchor).isActive = true
        typeTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        typeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        ethinicity.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        ethinicity.topAnchor.constraint(equalTo: restaurantType.bottomAnchor, constant: 5).isActive = true
        ethinicity.widthAnchor.constraint(equalToConstant: 120).isActive = true
        ethinicity.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        occupationTextField.leftAnchor.constraint(equalTo: ethinicity.rightAnchor, constant: 10).isActive = true
        occupationTextField.topAnchor.constraint(equalTo: ethinicity.topAnchor).isActive = true
        occupationTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        occupationTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        profileInfo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        profileInfo.topAnchor.constraint(equalTo: occupationTextField.bottomAnchor, constant: 5).isActive = true
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
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        occupationTextField.resignFirstResponder()
        profileInfoTextField.resignFirstResponder()
    }
}
extension Task2VC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
