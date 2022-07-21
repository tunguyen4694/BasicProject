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
    
    func addData(_ object: TransactionDetail) {
        try! database.write({
            object.ID = UUID().uuidString
            database.add(object)
        })
    }
    
    func getData() -> Results<TransactionDetail> {
        let results: Results<TransactionDetail> = database.objects(TransactionDetail.self)
        return results
    }
    
    func deleteAnObject(_ object: TransactionDetail) {
        try! database.write({
            let item = database.objects(TransactionDetail.self).where {
                $0.ID == object.ID
            }
            database.delete(item)
        })
    }
    
    func deleteAll() {
        try! database.write({
            database.deleteAll()
        })
    }
    
    func getDataArray() -> [TransactionDetail] {
        let result = database.objects(TransactionDetail.self).toArray(ofType: TransactionDetail.self)
        return result
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0..<count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
