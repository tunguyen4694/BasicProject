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
        
        btnLogin.layer.cornerRadius = 10
    }

    @IBAction func onSignup(_ sender: Any) {
        let vc = SignupVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
    }
    
}
