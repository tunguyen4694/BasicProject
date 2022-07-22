//
//  ModelReport.swift
//  MoneyManagementApp
//
//  Created by MorHN on 22/07/2022.
//

import Foundation

struct Report {
    init(name: String?, amount: Int?) {
        self.name = name
        self.amount = amount
    }
    
    let name: String?
    let amount: Int?
}
