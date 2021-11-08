//
//  MapChosenViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit
import CoreLocation
import Lottie

class MapChosenViewController: UIViewController {
    
    @IBOutlet weak var askLabel: UILabel!
        
    @IBOutlet weak var walkLabel: UILabel!

    lazy var walkYourselfButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("漫遊", for: .normal)
        button.titleLabel?.font = UIFont.kleeOneSemiBold(ofSize: 30)
        button.backgroundColor = UIColor.C4
        button.clipsToBounds = true
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = false
        button.layoutIfNeeded()
        return button
    }()
    
    lazy var walkFunButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("挑戰", for: .normal)
        button.titleLabel?.font = UIFont.kleeOneSemiBold(ofSize: 24)
        button.backgroundColor = UIColor.C2
        button.layer.cornerRadius = 20
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layoutIfNeeded()
        return button
    }()
    
    @IBOutlet weak var backgroundAnimationView: AnimationView!
    
    lazy var animationView: AnimationView = {
        
        var animationView = AnimationView()
        animationView = .init(name: "walking_outside")
        animationView.animationSpeed = 1
        animationView.layoutIfNeeded()
        return animationView
    }()
    
    var locationManager = CLLocationManager()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
                
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        setupWalkYourselfButton()

        setupWalkFunButton()

        setupLottie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupLottie()
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
    
    @objc func walkYourselfButtonPressed(_ sender: UIButton) {
        guard let mapSearchingPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "MapSearchingPage"
        ) as? MapSearchingPageViewController else { return }
        
        self.navigationController?.pushViewController(mapSearchingPagevc, animated: true)
    }
    
    @objc func walkFunButtonPressed(_ sender: UIButton) {
        guard let funnyMapPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "FunnyMapPage"
        ) as? FunnyMapViewController else { return }
        
        self.navigationController?.pushViewController(funnyMapPagevc, animated: true)
    }
    
    private func setupLottie() {
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.topAnchor.constraint(equalTo: walkFunButton.bottomAnchor, constant: -35),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
        animationView.loopMode = .loop
        animationView.play()
        
        backgroundAnimationView.loopMode = .loop
        backgroundAnimationView.play()
    }
    
    func setupWalkYourselfButton() {
        
        view.addSubview(walkYourselfButton)
        
        walkYourselfButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            walkYourselfButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            walkYourselfButton.topAnchor.constraint(equalTo: walkLabel.bottomAnchor, constant: 40),
            walkYourselfButton.widthAnchor.constraint(equalToConstant: 130),
            walkYourselfButton.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        walkYourselfButton.layer.cornerRadius = walkYourselfButton.frame.size.width / 2
        
        walkYourselfButton.addTarget(self, action: #selector(walkYourselfButtonPressed(_:)), for: .touchUpInside)
    }
    
    func setupWalkFunButton() {
        
        view.addSubview(walkFunButton)
        
        walkFunButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            walkFunButton.topAnchor.constraint(equalTo: walkLabel.bottomAnchor, constant: 120),
            walkFunButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            walkFunButton.widthAnchor.constraint(equalToConstant: 110),
            walkFunButton.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        walkFunButton.layer.cornerRadius = walkFunButton.frame.size.width / 2
                
        walkFunButton.addTarget(self, action: #selector(walkFunButtonPressed(_:)), for: .touchUpInside)
    }
}
