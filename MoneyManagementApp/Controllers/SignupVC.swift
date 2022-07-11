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
    @IBOutlet weak var btnSignup: UIButton!
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
        
        btnSignup.layer.cornerRadius = 10
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let vc = SignupVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func onCheck(_ sender: Any) {
        if !isCheck {
            btnCheck.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            isCheck = true
        } else {
            btnCheck.setImage(UIImage(systemName: "square"), for: .normal)
            isCheck = false
        }
    }
    
}
