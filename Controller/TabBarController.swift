//
//  ViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/16.
//

import UIKit
import FirebaseAuth

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let mapChosenvc = UINavigationController(rootViewController: mapChosenvc)
        
        let recordvc = UINavigationController(rootViewController: recordvc)
        
        let barChartvc = UINavigationController(rootViewController: barChartvc)
        
        let profilevc = UINavigationController(rootViewController: profilevc)
        
        self.setViewControllers([mapChosenvc, recordvc, barChartvc, profilevc], animated: false)
        
        self.tabBar.backgroundColor = .clear
        
        self.tabBar.tintColor = UIColor.hexStringToUIColor(hex: "#67A870")
    }
    
    func setupvcTitle() {
        
        mapChosenvc.tabBarItem.image = UIImage(systemName: "map")
        
        mapChosenvc.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        
        mapChosenvc.tabBarItem.title = "首頁"
        
        recordvc.tabBarItem.image = UIImage(systemName: "pawprint")
        
        recordvc.tabBarItem.selectedImage = UIImage(systemName: "pawprint.fill")
        
        recordvc.tabBarItem.title = "足跡"
        
        barChartvc.tabBarItem.image = UIImage(systemName: "chart.bar")
        
        barChartvc.tabBarItem.selectedImage = UIImage(systemName: "chart.bar.fill")
        
        barChartvc.tabBarItem.title = "紀錄"
        
        profilevc.tabBarItem.image = UIImage(systemName: "person.circle")
        
        profilevc.tabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")
         
        profilevc.tabBarItem.title = "會員"
    }
}
