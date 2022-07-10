//
//  ConvertNumber.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 07/07/2022.
//

import Foundation

class ConvertHelper {
    static let share = ConvertHelper()      // singleton pattern
    func stringFromNumber(currency: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.current
        
        let priceString = currencyFormatter.string(from: NSNumber(value: currency)) ?? "0"
        return priceString
    }
    
    func stringFromDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let string = formatter.string(from: date)
        
        return string
    }
}
