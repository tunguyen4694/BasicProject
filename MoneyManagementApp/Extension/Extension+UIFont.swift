//
//  Extension+UIFont.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 07/07/2022.
//

import UIKit

extension UIFont {
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    class func medium(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    class func semibold(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
