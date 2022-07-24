//
//  DBManager.swift
//  MoneyManagementApp
//
//  Created by MorHN on 21/07/2022.
//

import Foundation
import RealmSwift

class DBManager {
    private var database: Realm
    static let shareInstance = DBManager()
    
    private init() {
        database = try!Realm()
    }
    
    func addData(_ object: Transaction) {
        try! database.write({
            object.ID = UUID().uuidString
            database.add(object)
        })
    }
    
    func getData() -> Results<Transaction> {
        let results: Results<Transaction> = database.objects(Transaction.self).sorted(byKeyPath: "date", ascending: false)
        return results
    }
    
    func updateObject(_ object: Transaction, _ newObject: Transaction) {
        try! database.write({
            object.category = newObject.category
            object.image = newObject.image
            object.name = newObject.name
            object.date = newObject.date
            object.amount = newObject.amount
            object.stt = newObject.stt
        })
    }
    
    func deleteAnObject(_ object: Transaction) {
        try! database.write({
            database.delete(object)
        })
    }
    
    func deleteAll() {
        try! database.write({
            database.deleteAll()
        })
    }
}
