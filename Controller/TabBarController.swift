//
//  ViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/16.
//

import UIKit

class TabBarController: UITabBarController {
        
    let mapChosenvc = UIStoryboard.position.instantiateViewController(withIdentifier: "MapChosenViewController")
    
    let recordvc = UIStoryboard.record.instantiateViewController(withIdentifier: "Record")

    let barChartvc = UIStoryboard.barChart.instantiateViewController(withIdentifier: "BarChart")

    let profilevc = UIStoryboard.profile.instantiateViewController(withIdentifier: "Profile")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupvcTitle()
        setupTabBar()
    }

    func setupTabBar() {
        
        let mapChosennav = UINavigationController(rootViewController: mapChosenvc)
        
        let recordvc = UINavigationController(rootViewController: recordvc)
        
        let barChartvc = UINavigationController(rootViewController: barChartvc)
        
        let profilevc = UINavigationController(rootViewController: profilevc)
        
        self.setViewControllers([mapChosennav, recordvc, barChartvc, profilevc], animated: false)
        
        self.tabBar.backgroundColor = .clear
        
        self.tabBar.tintColor = UIColor.hexStringToUIColor(hex: "#67A870")        
    }
    
    func setupvcTitle() {
        
        mapChosenvc.tabBarItem.image = UIImage(systemName: "house")
        
        mapChosenvc.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        recordvc.tabBarItem.image = UIImage(systemName: "doc.on.doc")
        
        recordvc.tabBarItem.selectedImage = UIImage(systemName: "doc.on.doc.fill")
        
        barChartvc.tabBarItem.image = UIImage(systemName: "chart.bar")
        
        barChartvc.tabBarItem.selectedImage = UIImage(systemName: "chart.bar.fill")
        
        profilevc.tabBarItem.image = UIImage(systemName: "person.circle")
        
        profilevc.tabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")
    }
}
