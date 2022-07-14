//
//  ModelCategory.swift
//  MoneyManagementApp
//
//  Created by MorHN on 14/07/2022.
//

import Foundation
import UIKit

struct Category {
    let essentials: [Essential]
    let entertaiments: [Entertaiment]
    let educations: [Education]
    let investments: [Investment]
    let incomes: [Income]
    
    init(essentials: [Essential], entertaiments: [Entertaiment], educations: [Education], investments: [Investment], incomes: [Income]) {
        self.essentials = essentials
        self.entertaiments = entertaiments
        self.educations = educations
        self.investments = investments
        self.incomes = incomes
    }
}

struct Essential {
    var image: UIImage?
    var name: String?
    
    init(image: UIImage? = nil, name: String? = nil) {
        self.image = image
        self.name = name
    }
}

struct Entertaiment {
    var image: UIImage?
    var name: String?
    
    init(image: UIImage? = nil, name: String? = nil) {
        self.image = image
        self.name = name
    }
}

struct Education {
    var image: UIImage?
    var name: String?
    
    init(image: UIImage? = nil, name: String? = nil) {
        self.image = image
        self.name = name
    }
}

struct Investment {
    var image: UIImage?
    var name: String?
    
    init(image: UIImage? = nil, name: String? = nil) {
        self.image = image
        self.name = name
    }
}

struct Income {
    var image: UIImage?
    var name: String?
    
    init(image: UIImage? = nil, name: String? = nil) {
        self.image = image
        self.name = name
    }
}

func dataCategory() -> Category {
    var category: Category
    var dataEssential: [Essential] = []
    let dataEssential1 = Essential(image: .init(systemName: "house.fill"), name: "House Rent")
    let dataEssential2 = Essential(image: .init(systemName: "bolt.fill"), name: "Electricity/Water")
    let dataEssential3 = Essential(image: .init(systemName: "fork.knife"), name: "Foods")
    let dataEssential4 = Essential(image: .init(systemName: "fuelpump.fill"), name: "Petroleum")
    let dataEssential5 = Essential(image: .init(systemName: "flame.fill"), name: "Gas")
    let dataEssential6 = Essential(image: .init(systemName: "wifi"), name: "Internet")
    let dataEssential7 = Essential(image: .init(systemName: "phone.fill"), name: "Telephone")
    dataEssential.append(contentsOf: [dataEssential1, dataEssential2, dataEssential3, dataEssential4, dataEssential5, dataEssential6, dataEssential7])
    
    var dataEntertaiment: [Entertaiment] = []
    let dataEntertaiment1 = Entertaiment(image: .init(systemName: "cart.fill"), name: "Shopping")
    let dataEntertaiment2 = Entertaiment(image: .init(systemName: "ticket.fill"), name: "Cinema")
    let dataEntertaiment3 = Entertaiment(image: .init(systemName: "gamecontroller.fill"), name: "Game")
    let dataEntertaiment4 = Entertaiment(image: .init(systemName: "sportscourt.fill"), name: "Sport")
    let dataEntertaiment5 = Entertaiment(image: .init(systemName: "leaf.fill"), name: "Spa")
    dataEntertaiment.append(contentsOf: [dataEntertaiment1, dataEntertaiment2, dataEntertaiment3, dataEntertaiment4, dataEntertaiment5])
    
    var dataEdu: [Education] = []
    let dateEdu1 = Education(image: .init(systemName: "book.fill"), name: "Book")
    let dateEdu2 = Education(image: .init(systemName: "bag.fill"), name: "Education")
    dataEdu.append(contentsOf: [dateEdu1, dateEdu2])
    
    var dataInvest: [Investment] = []
    let dataInvest1 = Investment(image: .init(systemName: "bitcoinsign.circle.fill"), name: "Coin")
    let dataInvest2 = Investment(image: .init(systemName: "chart.xyaxis.line"), name: "Securities")
    let dataInvest3 = Investment(image: .init(systemName: "globe.asia.australia.fill"), name: "Real Estate")
    dataInvest.append(contentsOf: [dataInvest1, dataInvest2, dataInvest3])
    
    var dataIncome: [Income] = []
    let dataIncome1 = Income(image: .init(systemName: "dollarsign.circle.fill") , name: "Salary")
    let dataIncome2 = Income(image: .init(systemName: "network"), name: "Freelancer")
    let dataIncome3 = Income(image: .init(systemName: "chart.xyaxis.line"), name: "Investment")
    dataIncome.append(contentsOf: [dataIncome1, dataIncome2, dataIncome3])
    
    category = Category(essentials: dataEssential, entertaiments: dataEntertaiment, educations: dataEdu, investments: dataInvest, incomes: dataIncome)
    
    return category
}
