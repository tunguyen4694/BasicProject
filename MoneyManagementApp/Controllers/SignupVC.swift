//
//  SignupVC.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 10/07/2022.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var vUser: UIView!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnShowPassword: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var vSignup: UIView!
    @IBOutlet weak var btnCheck: UIButton!
    
    var isCheck = false
    
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
        
        btnSignup.layer.cornerRadius = 10
    }
    
    @IBAction func onShowPassword(_ sender: Any) {
        tfPassword.isSecureTextEntry = !tfPassword.isSecureTextEntry
        tfPassword.isSecureTextEntry ? btnShowPassword.setImage(UIImage(systemName: "eye"), for: .normal    ) : btnShowPassword.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let vc = LoginVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func onCheck(_ sender: Any) {
        if !isCheck {
            btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            vSignup.isHidden = true
            isCheck = true
        } else {
            btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
            vSignup.isHidden = false
            isCheck = false
        }
    }
}

extension SignupVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == nil {
            btnShowPassword.isHidden = true
        } else {
            btnShowPassword.isHidden = false
        }
    }
}
