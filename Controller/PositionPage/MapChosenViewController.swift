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
        button.titleLabel?.font = UIFont.semiBold(size: 30)
        button.buttonConfig(button, cornerRadius: 0)
        return button
    }()
    
    lazy var walkFunButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("挑戰", for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 24)
        button.buttonConfig(button, cornerRadius: 0)
        return button
    }()
    
    @IBOutlet weak var backgroundAnimationView: AnimationView!
    
    lazy var animationView: AnimationView = {
        
        var animationView = AnimationView()
        animationView = .init(name: String.walkingOutside)
        animationView.animationSpeed = 1
        animationView.layoutIfNeeded()
        return animationView
    }()
    
    var locationManager = CLLocationManager()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GoogleMapsManager.initLocationManager(locationManager, delegate: self)
                
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()

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
        guard let mapSearchingPageVC = UIStoryboard.position.instantiateViewController(
            withIdentifier: String(describing: MapSearchingPageViewController.self)
        ) as? MapSearchingPageViewController else { return }
        
        self.navigationController?.pushViewController(mapSearchingPageVC, animated: true)
    }
    
    @objc func walkFunButtonPressed(_ sender: UIButton) {
        guard let funnyMapPageVC = UIStoryboard.position.instantiateViewController(
            withIdentifier: String(describing: FunnyMapViewController.self)
        ) as? FunnyMapViewController else { return }
        
        self.navigationController?.pushViewController(funnyMapPageVC, animated: true)
    }
}

// MARK: - UI design
extension MapChosenViewController {
    
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
            walkYourselfButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2.75),
            walkYourselfButton.heightAnchor.constraint(equalToConstant: view.frame.width / 2.75)
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
            walkFunButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3.65),
            walkFunButton.heightAnchor.constraint(equalToConstant: view.frame.width / 3.65)
        ])
        
        walkFunButton.layer.cornerRadius = walkFunButton.frame.size.width / 2
                
        walkFunButton.addTarget(self, action: #selector(walkFunButtonPressed(_:)), for: .touchUpInside)
    }
}
