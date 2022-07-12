//
//  CustomTabBarController.swift
//  MoneyManagementApp
//
//  Created by MorHN on 12/07/2022.
//

import UIKit

class CustomTabBarController: UITabBarController {

    let vTopLineTabbar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        
        tabBar.tintColor = .mainColor()
        tabBar.unselectedItemTintColor = .iconTabBarColor()
//        tabBar.shadowImage = UIImage()
//        tabBar.backgroundImage = UIImage()
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default)
        
        let controller1 = HomeVC()
        controller1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill", withConfiguration: iconConfig), tag: 1)
        let nav1 = UINavigationController(rootViewController: controller1)
        
        let controller2 = ReportVC()
        controller2.tabBarItem = UITabBarItem(title: "Report", image: UIImage(systemName: "chart.bar.fill", withConfiguration: iconConfig), tag: 2)
        let nav2 = UINavigationController(rootViewController: controller2)
        
        let controller3 = AddTransactionVC()
        let nav3 = UINavigationController(rootViewController: controller3)
        nav3.title = ""
        
        let controller4 = WalletVC()
        controller4.tabBarItem = UITabBarItem(title: "Wallet", image: UIImage(systemName: "creditcard.fill", withConfiguration: iconConfig), tag: 4)
        let nav4 = UINavigationController(rootViewController: controller4)
        
        let controller5 = SettingVC()
        controller5.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "person.fill", withConfiguration: iconConfig), tag: 5)
        let nav5 = UINavigationController(rootViewController: controller5)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor: UIColor.borderColor()], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12),
             NSAttributedString.Key.foregroundColor: UIColor.mainColor()], for: .selected)
        
        configTabBar()
        //        tabBar.items![2].isEnabled = false
    }
    
    func configTabBar() {
        tabBar.addSubview(vTopLineTabbar)
        vTopLineTabbar.frame = .init(x: tabBar.frame.width/20, y: 0, width: tabBar.frame.width/10, height: 2)
        vTopLineTabbar.backgroundColor = .mainColor()
        
        let vShadow = UIView(frame: .init(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        let shadowLayer = CAShapeLayer()
        let shadowPath = UIBezierPath(rect: vShadow.bounds)
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.opacity = 0.05
        shadowLayer.shadowOffset = .zero
        shadowLayer.path = shadowPath.cgPath
        
        tabBar.layer.insertSublayer(shadowLayer, at: 0)
        
        let vClear = UIView()
        tabBar.addSubview(vClear)
        vClear.frame = .init(x: 0, y: tabBar.bounds.minY, width: 60, height: 60)
        vClear.center.x = tabBar.center.x
        vClear.backgroundColor = .clear
        
        let vBigCircle = UIView()
        tabBar.addSubview(vBigCircle)
        vBigCircle.frame = .init(x: 0, y: tabBar.bounds.minY-35, width: 70, height: 70)
        vBigCircle.center.x = tabBar.center.x
        vBigCircle.layer.cornerRadius = 35
        vBigCircle.backgroundColor = .white
        
        let vSmallCircle = UIView()
        vBigCircle.addSubview(vSmallCircle)
        vSmallCircle.frame = .init(x: 5, y: 5, width: 60, height: 60)
        vSmallCircle.layer.cornerRadius = 30
        vSmallCircle.backgroundColor = .mainColor()
        vSmallCircle.layer.masksToBounds = false
        vSmallCircle.layer.shadowColor = UIColor.black.cgColor
        vSmallCircle.layer.shadowOffset = .init(width: 0, height: 2)
        vSmallCircle.layer.shadowOpacity = 0.3
        
        let btnSearch = UIButton()
        vBigCircle.addSubview(btnSearch)
        btnSearch.setImage(UIImage(systemName: "plus"), for: .normal)
        btnSearch.tintColor = .white
        btnSearch.frame = .init(x: 0, y: 0, width: 70, height: 70)
        btnSearch.addTarget(self, action: #selector(onSearch(_:)), for: .touchUpInside)
        
    }
    
    @objc func onSearch(_ sender: UIButton) {
        let vc = AddTransactionVC()
        present(vc, animated: true)
    }
}

extension CustomTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        guard let indexOfTab = tabBar.items?.firstIndex(of: item) else { return }
        
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveLinear, animations: {
            self.vTopLineTabbar.transform = CGAffineTransform(translationX: self.tabBar.frame.width/5*CGFloat(indexOfTab), y: 0)
        }, completion: nil)
    }
}
