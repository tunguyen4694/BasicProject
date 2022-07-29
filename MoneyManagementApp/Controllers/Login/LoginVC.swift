//
//  LoginVC.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 10/07/2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import GoogleSignIn
import FBSDKLoginKit


class LoginVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var vUser: UIView!
    @IBOutlet weak var tfUser: UITextField!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: Setup UI
    func setupUI() {
        vUser.layer.borderWidth = 1
        vUser.layer.borderColor = UIColor.borderColor().cgColor
        vUser.layer.cornerRadius = 10
        
        vPassword.layer.borderWidth = 1
        vPassword.layer.borderColor = UIColor.borderColor().cgColor
        vPassword.layer.cornerRadius = 10
        
        tfPassword.isSecureTextEntry = true
        btnShowPassword.isHidden = true
        tfPassword.delegate = self
        
        btnLogin.layer.cornerRadius = 10
    }
    
    // MARK: Show Password
    @IBAction func onShowPassword(_ sender: Any) {
        tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        tfPassword.isSecureTextEntry ? btnShowPassword.setImage(UIImage(systemName: "eye"), for: .normal    ) : btnShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    @IBAction func onSignup(_ sender: Any) {
        let vc = SignupVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
    }
    
    // MARK: Login with Google
    @IBAction func loginWithGoogle(_ sender: Any) {
        let signInConfig = GIDConfiguration(clientID: "431516803603-9pc91p60dj7mb6jic8v3gg9vv1hljon3.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            if let error = error {
                print(error)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                        // The user is a multi-factor user. Second factor challenge is required.
                        let resolver = authError
                            .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                        var displayNameString = ""
                        for tmpFactorInfo in resolver.hints {
                            displayNameString += tmpFactorInfo.displayName ?? ""
                            displayNameString += " "
                        }
                        
                    } else {
                        
                        return
                    }
                    // ...
                    return
                }
                // User is signed in
                let vc = CustomTabBarController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    // MARK: Login with FB
    @IBAction func loginWithFB(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: self) { result, error in
            if let error = error {
                print("Encountered Erorr: \(error)")
            } else if let result = result, result.isCancelled {
                print("Cancelled")
            } else {
                print("Logged In")
                
                let credential = FacebookAuthProvider
                    .credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        let authError = error as NSError
                        if authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                            // The user is a multi-factor user. Second factor challenge is required.
                            let resolver = authError
                                .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                            var displayNameString = ""
                            for tmpFactorInfo in resolver.hints {
                                displayNameString += tmpFactorInfo.displayName ?? ""
                                displayNameString += " "
                            }
                        } else {
                            return
                        }
                        // ...
                        return
                    }
                    // User is signed in
                    let vc = CustomTabBarController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    // MARK: Login
    @IBAction func onHome(_ sender: Any) {
        let email = tfUser.text ?? ""
        let password = tfPassword.text ?? ""
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let _ = authResult {
                let vc = CustomTabBarController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            } else {
                let alertController = UIAlertController(title: "Error", message: "\(error?.localizedDescription ?? "")", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(ok)
                self.present(alertController, animated: true)
            }
        }
        
    }
}
// MARK: - Extention TextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if textField.text != nil {
        //            btnShowPassword.isHidden = false
        //        } else {
        //            btnShowPassword.isHidden = true
        //        }
        btnShowPassword.isHidden = textField.text == nil
    }
}
