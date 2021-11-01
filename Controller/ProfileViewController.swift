//
//  ProfileViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import Lottie

class ProfileViewController: UIViewController {
    
    lazy var animationView: AnimationView = {
        
        var animationView = AnimationView()
        animationView = .init(name: "profile_lottie")
        animationView.animationSpeed = 1
        return animationView
    }()
    
    lazy var waitLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35)
        label.text = "敬請期待..."
        label.textColor = UIColor.Celadon
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupLottie()
        setupLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLottie()
        setupLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        labelAnimation()
    }
    
    private func setupLottie() {
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20)
        ])
        animationView.loopMode = .loop
        animationView.play()
    }
    
    private func setupLabel() {
        
        view.addSubview(waitLabel)
        
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            waitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -180),
            waitLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
    
    func labelAnimation() {
        
        UIView.animate(withDuration: 6, delay: 0, options: [.repeat, .autoreverse, .curveLinear], animations: { [weak self] in
            guard let self = self else { return }
            self.waitLabel.center.x += self.view.bounds.height
            self.view.layoutIfNeeded()
          }, completion: nil)
    }
}
