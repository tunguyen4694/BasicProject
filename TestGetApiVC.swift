//
//  TestGetApiVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 20/07/2022.
//

import UIKit
import SwiftyJSON

class TestGetApiVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
//    let categotyUrl = "https://my-json-server.typicode.com/tunguyen4694/CategoryJSON/db"
    
    var json: JSON = JSON.null
    var datas: Categories?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let file = Bundle.main.path(forResource: "TestJSON", ofType: "json") else { return }
        do {
        let data = try Data(contentsOf: URL(fileURLWithPath: file))
        json = try JSON(data: data)
        } catch {
            return
        }
        
        print(json["essentials"].arrayValue)
        print(json["essentials"][0]["name"].stringValue)
        let name = json["essentials"].arrayValue.map {$0["name"].stringValue}
        print(name)
        
        
        
        
        
        
        
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UINib(nibName: "CategoryTBVC", bundle: nil), forCellReuseIdentifier: "CategoryTBVC")
    }

}

//extension TestGetApiVC: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        switch self.json.type {
//        case .array:
//            return self.json.count
//        default:
//            return 1
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//}
