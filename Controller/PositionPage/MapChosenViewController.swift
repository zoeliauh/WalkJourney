//
//  MapChosenViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit
import CoreLocation

class MapChosenViewController: UIViewController {
    
    @IBOutlet weak var walkLabel: UILabel!
    
    @IBOutlet weak var walkYourselfButton: UIButton!
    
    @IBOutlet weak var walkFunButton: UIButton!
    
    var locationManager = CLLocationManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
        
        walkYourselfButton.layer.cornerRadius = 20
        
        walkFunButton.layer.cornerRadius = 20
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupWalkYourselfButton()
        
        setupWalkFunButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        setupWalkYourselfButton()
        
        setupWalkFunButton()
    }
    
    @IBAction func walkYourselfButtonPressed(_ sender: UIButton) {
        guard let mapSearchingPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "MapSearchingPage"
        ) as? MapSearchingPageViewController else { return }
        
        self.navigationController?.pushViewController(mapSearchingPagevc, animated: true)
    }
    
    @IBAction func walkFunButtonPressed(_ sender: UIButton) {
        guard let funnyMapPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "FunnyMapPage"
        ) as? FunnyMapViewController else { return }
        
        self.navigationController?.pushViewController(funnyMapPagevc, animated: true)
    }
    
    func setupWalkYourselfButton() {
        
        let myAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.kleeOneRegular(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let myAttributeString = NSAttributedString(string: "我的路，我自己定義", attributes: myAttribute)
        
        walkYourselfButton.titleLabel?.attributedText = myAttributeString
    }

    func setupWalkFunButton() {
        
        let myAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.kleeOneRegular(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        let myAttributeString = NSAttributedString(string: "GPS art，趣味一下", attributes: myAttribute)
        
        walkFunButton.titleLabel?.attributedText = myAttributeString
    }
}
