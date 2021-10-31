//
//  MapChosenViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit

class MapChosenViewController: UIViewController {
    
    @IBOutlet weak var walkLabel: UILabel!
    
    @IBOutlet weak var walkYourselfButton: UIButton!
    
    @IBOutlet weak var walkFunButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walkYourselfButton.layer.cornerRadius = 20
        
        walkFunButton.layer.cornerRadius = 20
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
 
    @IBAction func walkYourselfButtonPressed(_ sender: UIButton) {
        guard let mapSearchingPagevc = UIStoryboard.position.instantiateViewController(withIdentifier: "MapSearchingPage") as? MapSearchingPageViewController else { return }
        
        self.navigationController?.pushViewController(mapSearchingPagevc, animated: true)
    }
    
    @IBAction func walkFunButtonPressed(_ sender: UIButton) {
        guard let funnyMapPagevc = UIStoryboard.position.instantiateViewController(withIdentifier: "FunnyMapPage") as? FunnyMapViewController else { return }
        
        self.navigationController?.pushViewController(funnyMapPagevc, animated: true)
    }
}
