//
//  ViewController.swift
//  Project28
//
//  Created by Yakup Aybars Bal on 19.02.2024.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet var secret: UITextView!
    
    var doneBtn: UIBarButtonItem! // challenge 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKey), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKey), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        title = "Nothing to see here"
        
        //challenge 1
        doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        navigationItem.rightBarButtonItem = doneBtn
        doneBtn.isHidden = true
    }
    
    @IBAction func authenticateTapped(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in
                
                DispatchQueue.main.async { [weak self] in
                    if success {
                        self?.unlockSecretMessage()
                        self?.secret.becomeFirstResponder()
                        self?.doneBtn.isHidden = false // challenge 1
                    } else {
//                        let ac = UIAlertController(title: "Authenticatin Failed", message: "You could not be verified; please try again", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .default))
//                        self?.present(ac, animated: true)
                        
                        self?.logInSignUp() // challenge 2
                    }
                }
            }
        } else {
//            let ac = UIAlertController(title: "Biometry Unavaliable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(ac, animated: true)
            
            logInSignUp() // challenge 2
        }
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret Stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        doneBtn.isHidden = true // challenge 1
        title = "Nothing to see here"
    }
    
    //challenge 2
    func logInSignUp() {
        let ac = UIAlertController(title: "Log in/ Sign Up", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Log In", style: .default, handler: logIn))
        ac.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: signUp))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func logIn(action: UIAlertAction) {
        let ac = UIAlertController(title: "Log In", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].placeholder = "User ID"
        ac.addTextField()
        ac.textFields?[1].placeholder = "Password"
        ac.textFields?[1].isSecureTextEntry = true
        ac.addAction(UIAlertAction(title: "Log In", style: .default, handler: { [weak ac, weak self] _ in
            guard let userID = ac?.textFields?[0].text else { return }
            guard let userPassword = ac?.textFields?[1].text else { return }
            
            if KeychainWrapper.standard.string(forKey: "\(userID)") == userPassword {
                self?.unlockSecretMessage()
                self?.doneBtn.isHidden = false // challenge 1
            } else {
                let ac = UIAlertController(title: "Error", message: "Wrong ID or Password", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(ac, animated: true)
            }
        }))
        present(ac, animated: true)
    }
    
    func signUp(action: UIAlertAction) {
        let ac = UIAlertController(title: "Create Your ID & Password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].placeholder = "User ID"
        ac.addTextField()
        ac.textFields?[1].placeholder = "Password"
        ac.textFields?[1].isSecureTextEntry = true
        ac.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { [weak ac] _ in
            guard let idText = ac?.textFields?[0].text else { return }
            guard let passwordText = ac?.textFields?[1].text else { return }
            
            KeychainWrapper.standard.set(passwordText, forKey: "\(idText)")
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    // MARK: - Adjusting Keyboard
    @objc func adjustForKey(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
}

