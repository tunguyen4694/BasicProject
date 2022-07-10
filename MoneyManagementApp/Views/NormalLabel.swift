//
//  NormalLabel.swift
//  MoneyManagementApp
//
//  Created by Nguyễn Anh Tú on 07/07/2022.
//

import UIKit

class NormalLabel: UILabel {
    
    convenience init(_ text: String, _ fontSize: CGFloat?) {
        self.init(frame: .zero)
        self.frame = .zero
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize ?? 13)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        self.textColor = UIColor.textColor()
    }
    
}
