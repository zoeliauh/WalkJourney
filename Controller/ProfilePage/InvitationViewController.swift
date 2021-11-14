//
//  InvitationViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/13.
//

import UIKit

class InvitationViewController: UIViewController {
    
    lazy var invitedTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(
            InvitedTableViewCell.self,
            forCellReuseIdentifier: InvitedTableViewCell.identifier
        )
        
        return tableView
    }()
    
    var invitedRequests: [Invitation] = [] {
        
        didSet {
            invitedTableView.dataSource = self
            invitedTableView.delegate = self
            invitedTableView.reloadData()
        }
    }
    
    var myID = UserManager.shared.uid
    
    var friendLists: [String] = []
    
    var senderInfo: [User] = []
    
    var senderID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        fetchInvitedRequest()
        
        fetchFriendList()
        
//        isModalInPresentation = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
        
        fetchInvitedRequest()
    }
    
    func fetchFriendList() {
        
        guard let myID = myID else { return }
        
        UserManager.shared.fetchUserInfo(uesrID: myID) { result in
            
            switch result {
                
            case .success(let friendList):
                guard let lists = friendList.friendLists else { return }
                        
                self.friendLists = lists
                                
            case .failure(let error):
                print("fetchAllInvitation.failure: \(error)")
                
            }
        }
    }

    func fetchInvitedRequest() {
        
        InvitationManager.shared.fetchInvitedRequest { result in
            
            switch result {
                
            case .success(let invitedRequest):
                self.invitedRequests = invitedRequest
                
            case .failure(let error):
                print("fetchAllInvitation.failure: \(error)")
            }
        }
        self.fetchUserInfo()
    }
            
    func fetchUserInfo() {
        
        for sender in invitedRequests {
            
            UserManager.shared.fetchUserInfo(uesrID: sender.sender) { result in
           
                switch result {
                                                            
                case .success(let senderInfo):
                                        
                    self.senderInfo.append(contentsOf: [senderInfo])
                    
                case .failure:
                    print("error for the sender info")
                }
            }
        }
    }
    
    @objc func confirmedPressed(_ sender: UIButton!) {
        
        self.friendLists.append(senderInfo[sender.tag].userID)
        
        UserManager.shared.updateFriendList(friendLists: friendLists)
        
        InvitationManager.shared.updateInvitedStatus(sender: senderInfo[sender.tag].userID)
        print(senderInfo[sender.tag].userID)
                
        sender.backgroundColor = .lightGray
        sender.isEnabled = false
    }
    
    @objc func notNowButtonPressed(_ sender: UIButton!) {
        
        InvitationManager.shared.deleteInvitedRequest(sender: senderInfo[sender.tag].userID)
        print(senderInfo[sender.tag].userID)
        senderInfo.remove(at: sender.tag)
        print(sender.tag)
        invitedTableView.reloadData()
    }
}

// MARK: - tableViewDelegate / tableViewDataSource
extension InvitationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senderInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InvitedTableViewCell.identifier, for: indexPath
        ) as? InvitedTableViewCell else { fatalError("can not dequeue") }
        
        cell.profileImageView.loadImage(senderInfo[indexPath.row].userImageURL,
                                        placeHolder: UIImage(systemName: "person.crop.circle")
        )
        
        cell.confirmedButton.tag = indexPath.row
        
        cell.notNowButton.tag = indexPath.row
        
        cell.userName.text = senderInfo[indexPath.row].username
        
        if invitedRequests[indexPath.row].accepted == 0 {
            
            cell.confirmedButtonIsEnable = true
            
            cell.notNowButtonIsEnable = true
            
            cell.confirmedButton.addTarget(self, action: #selector(confirmedPressed(_:)), for: .touchUpInside)
            
            cell.notNowButton.addTarget(self, action: #selector(notNowButtonPressed(_:)), for: .touchUpInside)
        } else {
            
            cell.confirmedButtonIsEnable = false
            
            cell.notNowButtonIsEnable = false
        }
        
        cell.selectionStyle = .none
                        
        return cell
    }
}

// MARK: - UI design
extension InvitationViewController {
    private func setupTableView() {
        
        view.addSubview(invitedTableView)
        
        invitedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            invitedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invitedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            invitedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invitedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
