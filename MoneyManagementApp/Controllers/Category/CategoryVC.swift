//
//  CategoryVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 14/07/2022.
//

import UIKit
import SwiftyJSON

class CategoryVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var json: JSON = JSON.null
    var datas = [Categories]()
    
    var passData: ((_ name: String?, _ image: UIImage?, _ imageWidth: CGFloat, _ leadingTextField: CGFloat) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        getCategoryApi()
        
        // Padding between section
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.backgroundColor = .separatorColor()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CategoryTBVC", bundle: nil), forCellReuseIdentifier: "CategoryTBVC")
    }
    
    func getCategoryApi() {
        guard let file = Bundle.main.path(forResource: "CategoryJSON", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            json = try JSON(data: data)
        } catch {
            return
        }
        
        let jsonData = json["categories"].arrayValue
        
        for item in jsonData {
            let category = Categories(item)
            datas.append(category)
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch datas[section].category {
        case "essentials":
            return "Essential"
        case "entertaiments":
            return "Entertaiment"
        case "educations":
            return "Education"
        case "investments":
            return "Investment"
        default:
            return "Income"
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
        let number = datas[section].name.count
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTBVC", for: indexPath) as! CategoryTBVC
        cell.selectionStyle = .none
        
        let name = datas[indexPath.section].name[indexPath.row]
        let image = UIImage(systemName: datas[indexPath.section].image[indexPath.row])
        
        cell.lblCategory.text = name
        cell.icon.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = datas[indexPath.section].name[indexPath.row]
        let image = UIImage(systemName: datas[indexPath.section].image[indexPath.row])
        
        passData?(name, image, 24, 8)
        
        dismiss(animated: true)
    }
}
