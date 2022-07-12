//
//  SettingVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit

class AccountVC: UIViewController {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrElement = ["General setting", "Edit account", "Rate application", "Share", "Help & About"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        imgAvatar.tintColor = .mainColor()
        tableView.backgroundColor = .borderColor()
        if #available(iOS 15.0, *) {        // Xoá line phân cách và padding giữa section và cell
            tableView.sectionHeaderTopPadding = 0.0
        }
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AccountTBVC", bundle: nil), forCellReuseIdentifier: "AccountTBVC")
    }
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vSection = UIView()
        vSection.backgroundColor = .borderColor()
        return vSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrElement.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTBVC", for: indexPath) as! AccountTBVC
            cell.lblElement.text = arrElement[indexPath.row]
            cell.separatorInset = .zero
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "logout")
            cell.textLabel?.text = "Log out"
            cell.textLabel?.font = .semibold(ofSize: 16)
            cell.textLabel?.textAlignment = .center
            cell.separatorInset = .zero
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
