//
//  ModelCategories.swift
//  MoneyManagementApp
//
//  Created by MorHN on 19/07/2022.
//

import UIKit
import SwiftyJSON

struct Categories: Decodable {
    var essentials: [Item]
    var entertaiments: [Item]
    var educations: [Item]
    var investments: [Item]
    var incomes: [Item]
}

struct Item: Decodable {
    var name: String
    var image: String
}
