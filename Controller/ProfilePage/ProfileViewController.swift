//
//  ProfileViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import FirebaseAuth
import Lottie

class ProfileViewController: UIViewController {
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
       return imageView
    }()

    lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Zoe"
        label.font = UIFont.kleeOneRegular(ofSize: 30)
        label.tintColor = .black
       return label
    }()
    // need to be stack view??
    lazy var rankImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.clipsToBounds = true
       return imageView
    }()
    
    lazy var challengeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "friends_invitation"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(funnyMapGame(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        
        let button = UIButton()
        let myAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.kleeOneRegular(ofSize: 24),
        ]
        let myAttributeString = NSAttributedString(string: "登出", attributes: myAttribute)
        
        button.backgroundColor = UIColor.DarkCeladon
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.setTitle("登出", for: .normal)
        button.titleLabel?.attributedText = myAttributeString
        button.layoutIfNeeded()
        button.addTarget(self, action: #selector(logOutAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var animationView: AnimationView = {
            
            var animationView = AnimationView()
            animationView = .init(name: "profile_lottie")
            animationView.animationSpeed = 1
            return animationView
    }()
    
    var tabbarHeight: CGFloat? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileImageView()
        setupNameLabel()
        setupRankImageView()
        setupChallengeButton()
//        setupLogoutButton()
//        setupLottie()
    }
    
    override func viewDidLayoutSubviews() {
        tabbarHeight = self.tabBarController?.tabBar.frame.height
        setupLogoutButton()
    }
    
    @objc func logOutAction(_ sender: UIButton) {
                
        let controller = UIAlertController(title: nil, message: "確定要登出嗎?", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "確定", style: .default) { _ in
            
            do {
                
                try Auth.auth().signOut()
                
                guard let loginVC = UIStoryboard.position.instantiateViewController(
                    withIdentifier: "LoginViewController"
                ) as? LoginViewController else { return }
                                
                loginVC.modalPresentationStyle = .fullScreen

                self.present(loginVC, animated: true, completion: nil)
                
                print("logout")
                
            } catch let signOutError as NSError {
                
               print("Error signing out: \(signOutError)")
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        controller.addAction(okAction)
        
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: UI design
    private func setupProfileImageView() {
        
        view.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setupNameLabel() {
        
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor)
        ])
    }
    
    func setupRankImageView() {
        
        view.addSubview(rankImageView)
        
        rankImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            rankImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            rankImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            rankImageView.widthAnchor.constraint(equalToConstant: 24),
            rankImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupChallengeButton() {
        
        view.addSubview(challengeButton)
        
        challengeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            challengeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            challengeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            challengeButton.widthAnchor.constraint(equalToConstant: 50),
            challengeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLogoutButton() {
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabbarHeight ?? 49.0) - 10),
            logoutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
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
    
    @objc func funnyMapGame(_ sender: UIButton!) {
        guard let funnyMapPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "FunnyMapPage"
        ) as? FunnyMapViewController else { return }

        self.navigationController?.pushViewController(funnyMapPagevc, animated: true)
    }
}
