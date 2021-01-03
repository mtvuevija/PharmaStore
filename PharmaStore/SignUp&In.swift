//
//  SignUp.swift
//  

import UIKit
import Firebase

class LogInController: UIViewController {
    var signin = false
    var verificationCode = ""
    var enteredCode = ""
    var phone = ""
    var hold: UIStackView = UIStackView()
    var phoneNumberView = UITextField()
    var codeView = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        hold = stackView
        view.addSubview(hold)
        
        NSLayoutConstraint.activate([
            //stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
        
        let logo = UIImageView(image: UIImage(named: "PharmaStore"))
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 75).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 28)
        name.text = "Log In"
        name.numberOfLines = 1
        name.textColor = .black
        
        
        let phoneNumber = UITextField()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        phoneNumber.font = UIFont.boldSystemFont(ofSize: 20)
        phoneNumber.textColor = .black
        phoneNumber.layer.cornerRadius = 15
        phoneNumber.layer.borderWidth = 5
        phoneNumber.heightAnchor.constraint(equalToConstant: 60).isActive = true
        phoneNumber.textAlignment = .center
        phoneNumber.keyboardType = UIKeyboardType.numberPad
        phoneNumberView = phoneNumber
        
        let code = UITextField()
        code.translatesAutoresizingMaskIntoConstraints = false
        code.attributedPlaceholder = NSAttributedString(string: "Enter Verification Code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        code.font = UIFont.boldSystemFont(ofSize: 20)
        code.textColor = .black
        code.layer.cornerRadius = 15
        code.layer.borderWidth = 5
        code.heightAnchor.constraint(equalToConstant: 60).isActive = true
        code.textAlignment = .center
        code.keyboardType = UIKeyboardType.numberPad
        code.isHidden = true
        codeView = code
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        phoneNumber.inputAccessoryView = toolbar
        code.inputAccessoryView = toolbar
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.backgroundColor = UIColor(red: 121 / 255, green: 83 / 255, blue: 179 / 255, alpha: 1)
        button.addTarget(self, action: #selector(login(button:)), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.numberOfLines = 1
        
        let buttonWrapper = UIView()
        buttonWrapper.translatesAutoresizingMaskIntoConstraints = false
        
        let signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up Here", for: .normal)
        signUpButton.setTitleColor(UIColor(ciColor: .blue).withAlphaComponent(0.4), for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        signUpButton.titleLabel?.numberOfLines = 1
        signUpButton.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        
        //stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(logo)
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(phoneNumber)
        stackView.addArrangedSubview(code)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            //name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        //name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //stackView.setCustomSpacing(5, after: name)
        stackView.setCustomSpacing(20, after: logo)
        stackView.setCustomSpacing(20, after: name)
        stackView.setCustomSpacing(30, after: phoneNumber)
        stackView.setCustomSpacing(30, after: code)
        stackView.setCustomSpacing(30, after: button)
    }
    @objc func login(button: UIButton) {
        print("bruh")
        if !self.signin && self.phoneNumberView.text!.count == 10 {
            print("bruh")
            PhoneAuthProvider.provider().verifyPhoneNumber("+" + "1" + phoneNumberView.text!, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    print(String(error!.localizedDescription))
                    return
                }
                self.signin.toggle()
                button.setTitle("Next", for: .normal)
                self.verificationCode = verificationID!
                self.phoneNumberView.isHidden = true
                self.codeView.isHidden = false
                print("Sent Verification Code")
            }
        }
        else if self.codeView.text!.count == 6 {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationCode, verificationCode: codeView.text!)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    print(String(error!.localizedDescription))
                    return
                }
                print("Signed In Successful")
                self.navigationController?.pushViewController(HomePageController(), animated: true)
            }
        }
    }
    
    @objc func goToSignUp() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}

class SignUpController: UIViewController {
    var signin = 1
    var verificationCode = ""
    var enteredCode = ""
    var phone = ""
    var hold: UIStackView = UIStackView()
    var phoneNumberView = UITextField()
    var codeView = UITextField()
    var nameView = UITextField()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        hold = stackView
        view.addSubview(hold)
        
        NSLayoutConstraint.activate([
            //stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
        
        let logo = UIImageView(image: UIImage(named: "PharmaStore"))
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 75).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 75).isActive = true
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.text = "Sign Up"
        label.numberOfLines = 1
        label.textColor = .black
        //view.addSubview(name)
        
        
        let phoneNumber = UITextField()
        phoneNumber.translatesAutoresizingMaskIntoConstraints = false
        phoneNumber.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        phoneNumber.font = UIFont.boldSystemFont(ofSize: 20)
        phoneNumber.textColor = .black
        phoneNumber.layer.cornerRadius = 15
        phoneNumber.layer.borderWidth = 5
        phoneNumber.heightAnchor.constraint(equalToConstant: 60).isActive = true
        phoneNumber.textAlignment = .center
        phoneNumber.keyboardType = UIKeyboardType.numberPad
        phoneNumberView = phoneNumber
        
        let code = UITextField()
        code.translatesAutoresizingMaskIntoConstraints = false
        code.attributedPlaceholder = NSAttributedString(string: "Enter Verification Code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        code.font = UIFont.boldSystemFont(ofSize: 20)
        code.textColor = .black
        code.layer.cornerRadius = 15
        code.layer.borderWidth = 5
        code.heightAnchor.constraint(equalToConstant: 60).isActive = true
        code.textAlignment = .center
        code.keyboardType = UIKeyboardType.numberPad
        code.isHidden = true
        codeView = code
        
        let name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.attributedPlaceholder = NSAttributedString(string: "Enter Your Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        name.font = UIFont.boldSystemFont(ofSize: 20)
        name.textColor = .black
        name.layer.cornerRadius = 15
        name.layer.borderWidth = 5
        name.heightAnchor.constraint(equalToConstant: 60).isActive = true
        name.textAlignment = .center
        name.keyboardType = UIKeyboardType.alphabet
        name.isHidden = true
        nameView = name
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(endEditing))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        phoneNumber.inputAccessoryView = toolbar
        code.inputAccessoryView = toolbar
        name.inputAccessoryView = toolbar
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor(red: 121 / 255, green: 83 / 255, blue: 179 / 255, alpha: 1)
        button.addTarget(self, action: #selector(testing(button:)), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.numberOfLines = 1
        
        let loginButton = UIButton()
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Log In Here", for: .normal)
        loginButton.setTitleColor(UIColor(ciColor: .blue).withAlphaComponent(0.4), for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        loginButton.titleLabel?.numberOfLines = 1
        loginButton.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        //stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(logo)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(phoneNumber)
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(code)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(loginButton)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            //name.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            //name.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        //name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //stackView.setCustomSpacing(5, after: name)
        stackView.setCustomSpacing(20, after: logo)
        stackView.setCustomSpacing(20, after: label)
        stackView.setCustomSpacing(30, after: phoneNumber)
        stackView.setCustomSpacing(30, after: name)
        stackView.setCustomSpacing(30, after: code)
        stackView.setCustomSpacing(30, after: button)
    }
    
    @objc func testing(button: UIButton) {
        print("bruh")
        view.endEditing(true)
        if self.signin == 1 && self.phoneNumberView.text!.count == 10 {
            print("bruh")
            PhoneAuthProvider.provider().verifyPhoneNumber("+" + "1" + phoneNumberView.text!, uiDelegate: nil) { (verificationID, error) in
                if error != nil {
                    print(String(error!.localizedDescription))
                    return
                }
                self.signin += 1
                //button.setTitle("Next", for: .normal)
                self.verificationCode = verificationID!
                self.phoneNumberView.isHidden = true
                self.codeView.isHidden = false
                print("Sent Verification Code")
            }
        }
        else if self.signin == 2 && self.codeView.text!.count == 6 {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationCode, verificationCode: codeView.text!)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    print(String(error!.localizedDescription))
                    return
                }
                self.nameView.isHidden = false
                self.codeView.isHidden = true
                print("Signed In Successful")
                self.signin += 1
                //self.navigationController?.pushViewController(SignUpPart2Controller(), animated: true)
            }
        }
        else if self.signin == 3 && self.nameView.text!.count > 0 {
            let db = Firestore.firestore()
            let uid = Auth.auth().currentUser?.uid
            db.collection("users").document(uid!).setData(["ID": uid!, "Name": nameView.text!, "MedName": [String](), "MedDosage": [String]()]) { (err) in
                if err != nil {
                    return
                }
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.navigationController?.pushViewController(HomePageController(), animated: true)
            }
        }
    }
    
    @objc func goToLogin() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(LogInController(), animated: true)
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
}
