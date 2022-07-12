//
//  HomeVC.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 10/07/2022.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var vBalance: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        vBalance.layer.cornerRadius = 10
        vBalance.layer.masksToBounds = false
        vBalance.layer.shadowColor = UIColor.black.cgColor
        vBalance.layer.shadowOpacity = 0.1
        vBalance.layer.shadowOffset = .init(width: 0, height: 2)
    }
    
}
