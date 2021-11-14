//
//  UserSearchViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/12.
//

import UIKit

class UserSearchViewController: UIViewController {
        
    lazy var userSearchTableView: UITableView = {
        
        let table = UITableView()
//        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(UserSearchTableViewCell.self, forCellReuseIdentifier: UserSearchTableViewCell.identifier)
        table.reloadData()

        return table
    }()
    
    var allUserInfo: [User] = [] {
        
        didSet {
            userSearchTableView.dataSource = self
//            userSearchTableView.reloadData()
        }
    }
    
    var filteredUserInfo: [User] = [] {
        
        didSet {
            userSearchTableView.dataSource = self
//            userSearchTableView.reloadData()
        }
    }
    
    var shouldShowSearchResults = false
    
    var userInvitation: [Invitation] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        fetchAllUserInfo()
        
        setupTableView()
        
        fetchUserInvitationInfo()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllUserInfo()
        
        setupTableView()
        
        fetchUserInvitationInfo()
    }
    
    func fetchAllUserInfo() {
        
        UserManager.shared.fetchAllUserInfo { result in
            
            switch result {
                
            case .success(let allUserInfo):
                
                self.allUserInfo = allUserInfo
//                print("aluserInfof is \(allUserInfo)")
                                
            case .failure(let error):
                
                print("fetchAllUserInfo.failure: \(error)")
            }
        }
    }
    
    func fetchUserInvitationInfo() {
        
        InvitationManager.shared.fetchUserInvitationInfo { result in
            
            switch result {
                
            case .success(let userInvitation):
                self.userInvitation = userInvitation
//                print("userInvitation is \(userInvitation)")
                
            case .failure(let error):
                print("fetchAllInvitation.failure: \(error)")
            }
        }
    }
}

extension UserSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            
            return filteredUserInfo.count
        } else {
            
            return allUserInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserSearchTableViewCell.identifier,
            for: indexPath) as? UserSearchTableViewCell else { fatalError() }
        
        if shouldShowSearchResults {
            
            if filteredUserInfo[indexPath.row].userImageURL == nil {
                
                cell.profileImageView.image = UIImage(systemName: "person.crop.circle")
            } else {
                
                cell.profileImageView.loadImage(filteredUserInfo[indexPath.row].userImageURL)
            }
            
            cell.userNameLabel.text = filteredUserInfo[indexPath.row].username
        } else {
            
            cell.profileImageView.loadImage(allUserInfo[indexPath.row].userImageURL)
            
            cell.userNameLabel.text = allUserInfo[indexPath.row].username
        }
        
        cell.addFriendButton.tag = indexPath.row
        
        cell.selectionStyle = .none

//        if allInvitation[indexPath.row].sender == UserManager.shared.uid && allInvitation[indexPath.row].receiver == allUserInfo[indexPath.row].userID {
//
//            cell.buttonIsEnable = false
//        } else {
//
//            cell.buttonIsEnable = true
//        }
        
        cell.addFriendButton.addTarget(self, action: #selector(sendInvitation(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func sendInvitation(_ sender: UIButton) {
        
        InvitationManager.shared.createInvitationRequest(searchNameResult: filteredUserInfo[sender.tag].userID)
        sender.backgroundColor = .lightGray
        sender.isEnabled = false
    }
}
// MARK: - UI design
extension UserSearchViewController {
    private func setupTableView() {
        
        view.addSubview(userSearchTableView)
        
        userSearchTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            userSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userSearchTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userSearchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
