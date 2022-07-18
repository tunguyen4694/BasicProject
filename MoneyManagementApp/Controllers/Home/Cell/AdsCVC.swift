//
//  AdsCVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 13/07/2022.
//

import UIKit

class AdsCVC: UICollectionViewCell {

    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var imgAds: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vContent.clipsToBounds = true
        vContent.layer.cornerRadius = 10
        imgAds.contentMode = .scaleAspectFill
    }
}
