//
//  ViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/16.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {
    
    let mapChosenvc = UIStoryboard.position.instantiateViewController(
        withIdentifier: String(describing: MapChosenViewController.self)
    )
    
    let recordCatagoryvc =
    UIStoryboard.record.instantiateViewController(
        withIdentifier: String(describing: RecordCatagoryViewController.self)
    )
    
    let profilevc = UIStoryboard.profile.instantiateViewController(
        withIdentifier: String(describing: ProfileViewController.self)
    )
    
    let galleryvc = UIStoryboard.gallery.instantiateViewController(
        withIdentifier: String(describing: GalleryViewController.self)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupvcTitle()
        setupTabBar()
        tabBar.backgroundColor = .C3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTabBar()
        tabBar.backgroundColor = .C3
    }
    
    func setupTabBar() {
        
        let mapChosenvc = UINavigationController(rootViewController: mapChosenvc)
        
        let recordvc = UINavigationController(rootViewController: recordCatagoryvc)
        
        let profilevc = UINavigationController(rootViewController: profilevc)
        
        let galleryvc = UINavigationController(rootViewController: galleryvc)
        
        self.setViewControllers([mapChosenvc, recordvc, galleryvc, profilevc], animated: false)
        
        self.tabBar.backgroundColor = .C3
        
        self.tabBar.tintColor = UIColor.C6
    }
    
    func setupvcTitle() {
        
        mapChosenvc.tabBarItem.image = UIImage.system(.map)
        
        mapChosenvc.tabBarItem.selectedImage = UIImage.system(.mapFill)
        
        mapChosenvc.tabBarItem.title = String.positionPage
        
        recordCatagoryvc.tabBarItem.image = UIImage.asset(.pawprint)
        
        recordCatagoryvc.tabBarItem.selectedImage = UIImage.asset(.pawprint_Fill)
        
        recordCatagoryvc.tabBarItem.title = String.recordPage
        
        galleryvc.tabBarItem.image = UIImage.system(.socialGroup)
        
        galleryvc.tabBarItem.selectedImage = UIImage.system(.socialGroupFill)
        
        galleryvc.tabBarItem.title = String.galleryPage
        
        profilevc.tabBarItem.image = UIImage.system(.profile)
        
        profilevc.tabBarItem.selectedImage = UIImage.system(.profileFill)
        
        profilevc.tabBarItem.title = String.profilePage
    }
}
