//
//  ModelTransaction.swift
//  MoneyManagementApp
//
//  Created by MorHN on 15/07/2022.
//

import Foundation
import UIKit

struct Transaction {
    init(image: UIImage? = nil, name: String? = nil, date: String? = nil, amount: String? = nil) {
        self.image = image
        self.name = name
        self.date = date
        self.amount = amount
    }
    
    var image: UIImage?
    var name: String?
    var date: String?
    var amount: String?
}
