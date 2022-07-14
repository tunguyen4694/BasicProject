//
//  CategoryVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 14/07/2022.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var datas: Category = dataCategory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        // Padding between section
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = .separatorColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoryTBVC", bundle: nil), forCellReuseIdentifier: "CategoryTBVC")
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Essential"
        case 1:
            return "Entertaiment"
        case 2:
            return "Education"
        case 3:
            return "Investment"
        case 4:
            return "Income"
        default:
            return ""
        }
    }
    
    // Set title header
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else { return }
//        header.textLabel?.textColor = .black
//        header.textLabel?.font = .bold(ofSize: 18)
//        header.textLabel?.frame = header.bounds
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return datas.essentials.count
        case 1:
            return datas.entertaiments.count
        case 2:
            return datas.educations.count
        case 3:
            return datas.investments.count
        case 4:
            return datas.incomes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTBVC", for: indexPath) as! CategoryTBVC
        switch indexPath.section {
        case 0:
            cell.icon.image = datas.essentials[indexPath.row].image
            cell.lblCategory.text = datas.essentials[indexPath.row].name
        case 1:
            cell.icon.image = datas.entertaiments[indexPath.row].image
            cell.lblCategory.text = datas.entertaiments[indexPath.row].name
        case 2:
            cell.icon.image = datas.educations[indexPath.row].image
            cell.lblCategory.text = datas.educations[indexPath.row].name
        case 3:
            cell.icon.image = datas.investments[indexPath.row].image
            cell.lblCategory.text = datas.investments[indexPath.row].name
        default:
            cell.icon.image = datas.incomes[indexPath.row].image
            cell.lblCategory.text = datas.incomes[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddTransactionVC()
        switch indexPath.section {
        case 0:
            vc.name = datas.essentials[indexPath.row].name ?? ""
        case 1:
            vc.name = datas.entertaiments[indexPath.row].name ?? ""
        case 2:
            vc.name = datas.educations[indexPath.row].name ?? ""
        case 3:
            vc.name = datas.investments[indexPath.row].name ?? ""
        default:
            vc.name = datas.incomes[indexPath.row].name ?? ""
        }
        dismiss(animated: true)
//        present(vc, animated: false)
        navigationController?.pushViewController(vc, animated: false)
    }
}
