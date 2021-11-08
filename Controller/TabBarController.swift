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
    
    let recordCatagoryvc =
    UIStoryboard.record.instantiateViewController(withIdentifier: "RecordCatagoryvc")

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
                
        let recordvc = UINavigationController(rootViewController: recordCatagoryvc)
        
        let barChartvc = UINavigationController(rootViewController: barChartvc)
        
        let profilevc = UINavigationController(rootViewController: profilevc)
        
        self.setViewControllers([mapChosenvc, recordvc, barChartvc, profilevc], animated: false)
        
        self.tabBar.backgroundColor = .C3
        
        self.tabBar.tintColor = UIColor.C6
    }
    
    func setupvcTitle() {
        
        mapChosenvc.tabBarItem.image = UIImage(systemName: "map")
        
        mapChosenvc.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        
        mapChosenvc.tabBarItem.title = "首頁"
        
        recordCatagoryvc.tabBarItem.image = UIImage(systemName: "pawprint")
        
        recordCatagoryvc.tabBarItem.selectedImage = UIImage(systemName: "pawprint.fill")
        
        recordCatagoryvc.tabBarItem.title = "足跡"
        
        barChartvc.tabBarItem.image = UIImage(systemName: "chart.bar")
        
        barChartvc.tabBarItem.selectedImage = UIImage(systemName: "chart.bar.fill")
        
        barChartvc.tabBarItem.title = "紀錄"
        
        profilevc.tabBarItem.image = UIImage(systemName: "person.circle")
        
        profilevc.tabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")
         
        profilevc.tabBarItem.title = "會員"
    }
}
