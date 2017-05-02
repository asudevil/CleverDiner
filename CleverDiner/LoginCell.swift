//
//  LoginCell.swift
//  PageViewControllerExample
//
//  Created by admin on 4/17/17.
//  Copyright © 2017 CodeWithFelix. All rights reserved.
//

import UIKit
import Firebase

class LoginCell: UICollectionViewCell, UITextFieldDelegate {
    
    var mainVC: MapViewController?
    
    let inputsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 5
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 230, g: 80, b: 0, a: 1)
        button.setTitle("User Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var busLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 230, g: 80, b: 0, a: 1)
        button.setTitle("Business Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleBizLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.masksToBounds = true
        return tf
    }()
    
    let nameSeperatorView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperatorView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        return lineView
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "the_clever_diner")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    lazy var termsOfServiceLink: UIButton = {
        let terms = UIButton(type: .system)
        terms.backgroundColor = UIColor(r: 103, g: 103, b: 103, a: 1)
        terms.setTitle("Terms of Service", for: .normal)
        terms.setTitleColor(UIColor(r: 230, g: 80, b: 0, a: 1), for: .normal)
        terms.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        terms.addTarget(self, action: #selector(handleTermsOfService), for: .touchUpInside)
        terms.translatesAutoresizingMaskIntoConstraints = false
        terms.layer.masksToBounds = true
        return terms
    }()
    
    lazy var privacyPolicyLink: UIButton = {
        let privacyButton = UIButton(type: .system)
        privacyButton.backgroundColor = UIColor(r: 103, g: 103, b: 103, a: 1)
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.setTitleColor(UIColor(r: 230, g: 80, b: 0, a: 1), for: .normal)
        privacyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        privacyButton.addTarget(self, action: #selector(handlePrivacyPolicy), for: .touchUpInside)
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyButton.layer.masksToBounds = true
        return privacyButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(r: 103, g: 103, b: 103, a: 1)
        addSubview(inputsContainerView)
        addSubview(loginRegisterButton)
        addSubview(profileImageView)
        addSubview(loginRegisterSegmentedControl)
        addSubview(busLoginButton)
        addSubview(termsOfServiceLink)
        addSubview(privacyPolicyLink)
        
        setupInputContrainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupBusLoginButton()
        setupTermsOfServiceLink()
        setupPrivacyPolicyLink()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    func handleTermsOfService() {
        if let url = URL(string: "http://example.com") {
            UIApplication.shared.openURL(url)
        }
    }
    func handlePrivacyPolicy() {
        if let url = URL(string: "http://example.com") {
            UIApplication.shared.openURL(url)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
        UserDefaults.standard.setIsReturningUser(value: true)
        UserDefaults.standard.setIsBusinessUser(value: false)
    }
    
    func handleBizLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
        UserDefaults.standard.setIsReturningUser(value: true)
        UserDefaults.standard.setIsBusinessUser(value: true)
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("Error Logging in !!!!!!", error!)
                
                let title = "Error Logging In"
                let message = "Username or password is incorrect. Please check and try again."
                let action = "OK"
                
                self.loginRegisterAlert(title: title, message: message, action: action)
                
                return
            }
            print("DONE LOGING IN!!")
            self.window?.rootViewController?.dismiss(animated: true, completion: nil)
        })
        UserDefaults.standard.setIsReturningUser(value: true)
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                let title = "Error Registering"
                let message = "Please enter a valid user name, email and password with six or more characters"
                let action = "OK"
                
                self.loginRegisterAlert(title: title, message: message, action: action)
                print(error!)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            //Successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        //Basic Info
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                        
                        //Detail Info
                        let userDetails = ["userName": name, "email": email, "imageUrl": profileImageUrl, "firstName": "", "lastName": "", "location": "", "gender": "", "phone":"", "occupation":"", "linkedIn":"", "details":""]
                        self.addUserDetailsIntoDataBaseWithUID(uid: uid, values: userDetails)
                        ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: userDetails)
                    }
                })
            } else {
                //Basic Info
                let values = ["name": name, "email": email, "profileImageUrl": ""]
                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                //Detail Info
                let userDetails = ["userName": name, "email": email, "imageUrl": "", "firstName": "", "lastName": "", "location": "", "gender": "", "phone":"", "occupation":"", "linkedIn":"", "details":""]
                self.addUserDetailsIntoDataBaseWithUID(uid: uid, values: userDetails)
                ProfileDetails.sharedInstance.setProfileDetails(profileDictionary: userDetails)
            }
        })
    }

    func loginRegisterAlert(title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default, handler: nil))
        
        self.parentViewController?.present(alert, animated: true, completion: nil)
    }

    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users").child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
            self.mainVC?.navigationItem.title = values["name"] as? String
            self.window?.rootViewController?.dismiss(animated: true, completion: nil)

        })
    }
    
    private func addUserDetailsIntoDataBaseWithUID(uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users-details").child(uid)
        userReference.updateChildValues(values) { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        }
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func handleLoginRegisterChange () {
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle("User \(title ?? "")", for: .normal)
        busLoginButton.setTitle("Business \(title ?? "")", for: .normal)
        
        
        // change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 90 : 130
        
        //change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
        
        //Change Image:
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            profileImageView.image = UIImage(named: "the_clever_diner")
        } else if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            profileImageView.image = UIImage(named: "the_clever_diner")
        }
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -5).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func setupInputContrainerView() {
        
        //x, y, width and height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 130)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 3).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    func setupBusLoginButton() {
        busLoginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        busLoginButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 3).isActive = true
        busLoginButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        busLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupTermsOfServiceLink() {
        termsOfServiceLink.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        termsOfServiceLink.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        termsOfServiceLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        termsOfServiceLink.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
    }
    func setupPrivacyPolicyLink() {
        privacyPolicyLink.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        privacyPolicyLink.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        privacyPolicyLink.heightAnchor.constraint(equalToConstant: 20).isActive = true
        privacyPolicyLink.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
