//
//  SettingViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/8.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    lazy var invitationButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle("好友邀請", for: .normal)
        button.addTarget(self, action: #selector(invitedPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var friendListsButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle("好友名單", for: .normal)
        button.addTarget(self, action: #selector(firendListsPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var blockLishButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle("黑名單", for: .normal)
        button.addTarget(self, action: #selector(blockListsPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteAccountButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle("刪除帳戶", for: .normal)
        button.addTarget(self, action: #selector(deleteAccount(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var policyButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle("隱私權條款", for: .normal)
        button.addTarget(self, action: #selector(presentPolicy(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle("登出", for: .normal)
        button.addTarget(self, action: #selector(logOutAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(closeButtonPress(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        isModalInPresentation = true
        
        setupCloseButton()
                
        setupButtons()
    }
    
    private func configButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont.kleeOneSemiBold(ofSize: 18)
        button.backgroundColor = UIColor.C4
        button.tintColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        button.layoutIfNeeded()
    }
    
    @objc func invitedPressed(_ sender: UIButton) {
        
        guard let invitationVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "InvitationViewController"
        ) as? InvitationViewController else { return }

        self.present(invitationVC, animated: true, completion: nil)
    }
    
    @objc func firendListsPressed(_ sender: UIButton) {
        
        guard let firendListsVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "FriendListsViewController"
        ) as? FriendListsViewController else { return }

        self.present(firendListsVC, animated: true, completion: nil)
    }
    
    @objc func blockListsPressed(_ sender: UIButton) {
        
        guard let blockListsVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "BlockListsViewController"
        ) as? BlockListsViewController else { return }

        self.present(blockListsVC, animated: true, completion: nil)
    }
    
    @objc func deleteAccount(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "請聯絡我們幫您刪除帳戶", message: "woanjwuliauh@gmail.com", preferredStyle: .alert )
        let okButton = UIAlertAction(title: "ok", style: .default)
        
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
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
    
    private func setupButtons() {
        
        view.addSubview(invitationButton)
        view.addSubview(friendListsButton)
        view.addSubview(blockLishButton)
        view.addSubview(deleteAccountButton)
        view.addSubview(policyButton)
        view.addSubview(logoutButton)
        
        invitationButton.translatesAutoresizingMaskIntoConstraints = false
        friendListsButton.translatesAutoresizingMaskIntoConstraints = false
        blockLishButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        policyButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            invitationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            invitationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            invitationButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 8),
            invitationButton.heightAnchor.constraint(equalToConstant: 35),
            
            friendListsButton.widthAnchor.constraint(equalTo: invitationButton.widthAnchor),
            friendListsButton.heightAnchor.constraint(equalTo: invitationButton.heightAnchor),
            friendListsButton.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor),
            friendListsButton.topAnchor.constraint(equalTo: invitationButton.bottomAnchor, constant: 30),

            blockLishButton.widthAnchor.constraint(equalTo: invitationButton.widthAnchor),
            blockLishButton.heightAnchor.constraint(equalTo: invitationButton.heightAnchor),
            blockLishButton.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor),
            blockLishButton.topAnchor.constraint(equalTo: friendListsButton.bottomAnchor, constant: 30),
            
            deleteAccountButton.widthAnchor.constraint(equalTo: invitationButton.widthAnchor),
            deleteAccountButton.heightAnchor.constraint(equalTo: invitationButton.heightAnchor),
            deleteAccountButton.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor),
            deleteAccountButton.topAnchor.constraint(equalTo: blockLishButton.bottomAnchor, constant: 30),
            
            policyButton.widthAnchor.constraint(equalTo: invitationButton.widthAnchor),
            policyButton.heightAnchor.constraint(equalTo: invitationButton.heightAnchor),
            policyButton.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor),
            policyButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 30),
            
            logoutButton.widthAnchor.constraint(equalTo: invitationButton.widthAnchor),
            logoutButton.heightAnchor.constraint(equalTo: invitationButton.heightAnchor),
            logoutButton.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor),
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
