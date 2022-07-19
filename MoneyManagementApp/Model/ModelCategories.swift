//
//  ModelCategories.swift
//  MoneyManagementApp
//
//  Created by MorHN on 19/07/2022.
//

import Foundation
import UIKit

struct Categories {
    init(header: Categories.Header, items: [DataItem]) {
        self.header = header
        self.items = items
    }
    
    
    enum Header {
        case Essential
        case Entertaiment
        case Education
        case Investment
        case Income
    }
    
    var header: Header
    var items: [DataItem]
}

struct DataItem {
    init(image: UIImage, name: String) {
        self.image = image
        self.name = name
    }
    
    var image: UIImage
    var name: String
}
