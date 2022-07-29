//
//  SettingVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit
import FirebaseAuth

class AccountVC: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var arrElement = ["General setting", "Edit account", "Rate application", "Share", "Help & About"]
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    // MARK: Setup UI
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
        
        // MARK: Get user avatar
        if let user = Auth.auth().currentUser {
            guard let urlImage = user.photoURL else { return }
            do {
                let imgData = try Data(contentsOf: urlImage)
                imgAvatar.image = UIImage(data: imgData)
            } catch {
                print("Error when get image: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDelegate, DataSource
extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vSection = UIView()
        vSection.backgroundColor = .separatorColor()
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
            
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "logout")
            cell.textLabel?.text = "Log out"
            cell.textLabel?.font = .semibold(ofSize: 16)
            cell.textLabel?.textAlignment = .center
            cell.separatorInset = .zero
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: Logout
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                let vc = LoginVC()
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
}
