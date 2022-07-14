//
//  AddTransactionVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit

class AddTransactionVC: UIViewController {

    @IBOutlet weak var vSafe: UIView!
    @IBOutlet weak var vLine: UIView!
    
    @IBOutlet weak var btnExpense: UIButton!
    @IBOutlet weak var btnIncome: UIButton!
    
    @IBOutlet weak var vCategory: UIView!
    @IBOutlet weak var vAmount: UIView!
    @IBOutlet weak var vDate: UIView!
    
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfDate: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tfCategory.text = name
        tfAmount.keyboardType = .numberPad
        setupUI()
        configNavigationBar()
    }
    
    @IBAction func onBack(_ sender: Any) {
        let vc = CustomTabBarController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addExpense(_ sender: Any) {
        btnSave.tag = 0
        btnExpense.tintColor = .mainColor()
        btnExpense.titleLabel?.font = .semibold(ofSize: 16)
        btnIncome.tintColor = .black
        btnIncome.titleLabel?.font = .medium(ofSize: 16)
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.vLine.transform = CGAffineTransform(translationX: self.vLine.bounds.width*CGFloat((self.btnSave.tag)), y: 0)
        }, completion: nil)
    }
    
    @IBAction func addIncome(_ sender: Any) {
        btnSave.tag = 1
        btnExpense.titleLabel?.font = .medium(ofSize: 16)
        btnExpense.tintColor = .black
        btnIncome.tintColor = .mainColor()
        btnIncome.titleLabel?.font = .semibold(ofSize: 16)
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.vLine.transform = CGAffineTransform(translationX: self.vLine.bounds.width*CGFloat((self.btnSave.tag)), y: 0)
        }, completion: nil)
    }
    
    @IBAction func enterCategory(_ sender: Any) {
        let vc = CategoryVC()
//        present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .mainColor()
        navigationItem.title = "Add transaction"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bold(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "chevron.backward")
        navigationController?.navigationBar.backItem?.title = ""
    }
    
    func setupUI() {
//        vSafe.backgroundColor = .mainColor()
        vLine.backgroundColor = .mainColor()
            
        vCategory.layer.borderWidth = 1
        vCategory.layer.borderColor = UIColor.borderColor().cgColor
        vCategory.layer.cornerRadius = 10
        
        vAmount.layer.borderWidth = 1
        vAmount.layer.borderColor = UIColor.borderColor().cgColor
        vAmount.layer.cornerRadius = 10
        
        vDate.layer.borderWidth = 1
        vDate.layer.borderColor = UIColor.borderColor().cgColor
        vDate.layer.cornerRadius = 10
        
        btnSave.layer.cornerRadius = 10
        btnSave.tintColor = .mainColor()
        btnSave.tag = 0
    }
}
