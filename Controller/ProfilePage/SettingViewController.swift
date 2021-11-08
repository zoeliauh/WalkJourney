//
//  SettingViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/8.
//

import UIKit
import FirebaseAuth

class SettingViewController: UIViewController {
    
    let settingItem = [
    
    SettingStruct(itme: "緊急聯絡方式"),
    SettingStruct(itme: "支援"),
    SettingStruct(itme: "登出"),
    SettingStruct(itme: "帳戶刪除")
    ]
    
    lazy var logoutButton: UIButton = {
        
        let button = UIButton()
        let myAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.kleeOneRegular(ofSize: 24)
        ]
        let myAttributeString = NSAttributedString(string: "登出", attributes: myAttribute)
        
        button.backgroundColor = UIColor.C4
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 10
        button.setTitle("登出", for: .normal)
        button.titleLabel?.attributedText = myAttributeString
        button.layoutIfNeeded()
        button.addTarget(self, action: #selector(logOutAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    lazy var settingTableView: UITableView = {
        
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
//        table.allowsSelection = false
        table.reloadData()

        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        isModalInPresentation = true
        
        setupCloseButton()
        
        setupSettingTableView()
        
        setupLogoutButton()
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("click Label")
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
    
    private func setupLogoutButton() {
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55),
            logoutButton.heightAnchor.constraint(equalToConstant: 40)
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
        
        closeButton.addTarget(self, action: #selector(closeButtonPress(_:)), for: .touchUpInside)
    }
    
    func setupSettingTableView() {
        
        view.addSubview(settingTableView)
        
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingTableView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingTableViewCell.identifier, for: indexPath
        ) as? SettingTableViewCell else { fatalError("can not dequeue settingTableViewCell") }
        
        cell.itemLabel.text = settingItem[indexPath.row].itme

        cell.itemLabel.tag = indexPath.item
        
        cell.selectionStyle = .none
        
        let labelTap = UIGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        
        cell.itemLabel.addGestureRecognizer(labelTap)
        
        return cell
    }
}
