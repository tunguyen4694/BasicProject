//
//  RealmTest.swift
//  MoneyManagementApp
//
//  Created by MorHN on 21/07/2022.
//

import Foundation
import RealmSwift

class TransactionDetail: Object {
    
    @objc dynamic var ID = ""
    @objc dynamic var image: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var date: Date?
    @objc dynamic var amount: String = ""
    @objc dynamic var stt: String = ""
//    @objc dynamic var color: UIColor?
    
    override class func primaryKey() -> String? {
        return "ID"
    }
    
    convenience init(image: String, name: String, date: Date? = nil, amount: String, stt: String) {
        self.init()
//        self.ID = ID
        self.image = image
        self.name = name
        self.date = date
        self.amount = amount
        self.stt = stt
//        self.color = color
    }
}
