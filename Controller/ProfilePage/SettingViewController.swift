//
//  SettingViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/8.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        setupCloseButton()
                
        setupButtons()
    }
    
    @objc func deleteAccount(_ sender: UIButton) {
        
        present(.confirmationAlert(
            title: "請聯絡我們幫您刪除帳戶", message: "woanjwuliauh@gmail.com",
            preferredStyle: .alert,
            actions: [UIAlertAction.addAction(
                title: "ok", style: .default, handler: nil)
                     ]), animated: true, completion: nil)
    }
    
    @objc func presentPolicy(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Position", bundle: nil)
        guard let policyVc = storyboard.instantiateViewController(
            withIdentifier: String(describing: PrivacyPolicyViewController.self)
        ) as? PrivacyPolicyViewController else { return }
        
        present(policyVc, animated: true, completion: nil)
    }
    
    @objc func closeButtonPress(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func logOutAction(_ sender: UIButton) {
        
        present(.confirmationAlert(
            title: nil, message: "確定要登出嗎?",
            preferredStyle: .alert,
            actions: [UIAlertAction.addAction(title: String.confirmed, style: .default, handler: { [weak self] _ in
                
                do {
                    
                    try Auth.auth().signOut()
                    
                    guard let loginVC = UIStoryboard.position.instantiateViewController(
                        withIdentifier: String(describing: LoginViewController.self)
                    ) as? LoginViewController else { return }
                    
                    loginVC.modalPresentationStyle = .fullScreen
                    
                    self?.present(loginVC, animated: true, completion: nil)
                    
                    print("logout")
                    
                } catch let signOutError as NSError {
                    
                    print("Error signing out: \(signOutError)")
                    
                }
            }), UIAlertAction.addAction(title: String.cancel, style: .destructive, handler: nil)
                     ]
        ), animated: true, completion: nil)
    }
    
    lazy var deleteAccountButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 10)
        button.setTitle("刪除帳戶", for: .normal)
        button.addTarget(self, action: #selector(deleteAccount(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var policyButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 10)
        button.setTitle("隱私權條款", for: .normal)
        button.addTarget(self, action: #selector(presentPolicy(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        
        let button = UIButton()
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 10)
        button.setTitle("登出", for: .normal)
        button.addTarget(self, action: #selector(logOutAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.system(.xMark), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(closeButtonPress(_:)), for: .touchUpInside)
        return button
    }()
}

// MARK: - UI design
extension SettingViewController {
    
    private func setupButtons() {
        
        view.addSubview(deleteAccountButton)
        view.addSubview(policyButton)
        view.addSubview(logoutButton)
        
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        policyButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            deleteAccountButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 8),
            deleteAccountButton.heightAnchor.constraint(equalToConstant: 35),
            
            policyButton.widthAnchor.constraint(equalTo: deleteAccountButton.widthAnchor),
            policyButton.heightAnchor.constraint(equalTo: deleteAccountButton.heightAnchor),
            policyButton.centerXAnchor.constraint(equalTo: deleteAccountButton.centerXAnchor),
            policyButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 30),
            
            logoutButton.widthAnchor.constraint(equalTo: deleteAccountButton.widthAnchor),
            logoutButton.heightAnchor.constraint(equalTo: deleteAccountButton.heightAnchor),
            logoutButton.centerXAnchor.constraint(equalTo: deleteAccountButton.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: policyButton.bottomAnchor, constant: 30)
        ])
    }
    
    private func setupCloseButton() {
        
        view.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
