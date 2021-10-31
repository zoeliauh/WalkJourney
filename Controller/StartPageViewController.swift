//
//  StartPageViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/31.
//

import UIKit

class StartPageViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var goButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func goButtonPressed(_ sender: UIButton!) {
        
        guard let mapChosenViewController = UIStoryboard.position.instantiateViewController(withIdentifier: "MapChosenViewController") as? MapChosenViewController else { return }
        
        self.navigationController?.pushViewController(mapChosenViewController, animated: true)
    }
}
