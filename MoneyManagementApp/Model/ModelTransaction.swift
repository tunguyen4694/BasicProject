//
//  ModelTransaction.swift
//  MoneyManagementApp
//
//  Created by MorHN on 15/07/2022.
//

import Foundation
import UIKit

struct Transaction {
    init(image: UIImage? = nil, name: String? = nil, date: Date? = nil, amount: String? = nil, stt: String? = nil, color: UIColor? = nil) {
        self.image = image
        self.name = name
        self.date = date
        self.amount = amount
        self.stt = stt
        self.color = color
    }
    
    var image: UIImage?
    var name: String?
    var date: Date?
    var amount: String?
    var stt: String?
    var color: UIColor?
}
