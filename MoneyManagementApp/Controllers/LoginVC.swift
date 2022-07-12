//
//  LoginVC.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 10/07/2022.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var vUser: UIView!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
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
}

extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text != nil {
            btnShowPassword.isHidden = false
        } else {
            btnShowPassword.isHidden = true
        }
    }
}
