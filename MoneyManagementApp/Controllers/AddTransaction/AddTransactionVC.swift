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
    var currentString = ""
    
    var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.timeZone = TimeZone.current
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfAmount.delegate = self
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
        vc.passData = { [weak self] name in
            guard let strongSelf = self, let name = name else { return }
            strongSelf.tfCategory.text = name
        }
        present(vc, animated: true)
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        tfDate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func datePickerDone() {
        tfDate.resignFirstResponder()
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
        
        tfAmount.keyboardType = .numberPad
        tfDate.placeholder = ConvertHelper.share.stringFromDate(date: Date(), format: "dd/MM/yyyy")
        // Setup Date Picker input Text Field
        tfDate.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
        // Set btnDone in datePicker view
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        tfDate.inputAccessoryView = toolBar
    }
    
    // Currenct Fomatter in TextField
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        let numberFromField = NSString(string: currentString).doubleValue
        tfAmount.text = formatter.string(from: NSNumber(value: numberFromField))
    }
}

// Extension Currenct Fomatter in TextField
extension AddTransactionVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            formatCurrency(string: currentString)
        default:
            if string.count == 0 && currentString.count != 0 {
                currentString = String(currentString.dropLast())
                formatCurrency(string: currentString)
            }
        }
        return false
    }
}
