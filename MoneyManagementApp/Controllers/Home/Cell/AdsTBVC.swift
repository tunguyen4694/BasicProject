//
//  TransactionTBVC.swift
//  MoneyManagementApp
//
//  Created by MorHN on 13/07/2022.
//

import UIKit

class AdsTBVC: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrAds = ["ads1", "ads2"]
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "AdsCVC", bundle: nil), forCellWithReuseIdentifier: "AdsCVC")
    }
}

extension AdsTBVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdsCVC", for: indexPath) as! AdsCVC
        cell.imgAds.image = UIImage(named: arrAds[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width*2/3, height: collectionView.bounds.height)
    }
}
