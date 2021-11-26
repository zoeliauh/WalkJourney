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
            
            invitedTableView.reloadData()
        }
    }
    
    var myID = UserManager.shared.uid
    
    var friendLists: [String] = []
    
    var senderFriendLists: [String] = []
        
    var senderInfo: [String: User] = [:]
    
    var senderID: String = "" {
        
        didSet {
            
            fetchSenderFriendList()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchInvitedRequest()
        
        fetchFriendList()
                
        setupTableView()
    }
    
    func fetchFriendList() {
        
        guard let myID = myID else { return }
        
        UserManager.shared.fetchUserInfo(userID: myID) { result in
            
            switch result {
                
            case .success(let friendList):
                guard let lists = friendList.friendLists else { return }
                        
                self.friendLists = lists
                                
            case .failure(let error):
                print("fetchAllInvitation.failure: \(error)")
                
            }
        }
    }
    
    func fetchSenderFriendList() {
                        
        UserManager.shared.fetchUserInfo(userID: senderID) { result in
                        
            switch result {
                
            case .success(let friendList):
                guard let lists = friendList.friendLists else { return }
                        
                self.senderFriendLists = lists
                                                
            case .failure(let error):
                print("fetchSenderFriendLists.failure: \(error)")
                
            }
        }
    }

    func fetchInvitedRequest() {
        
        InvitationManager.shared.fetchInvitedRequest { result in
            
            switch result {
                
            case .success(let invitedRequest):
                
                let group = DispatchGroup()
                
                self.invitedRequests = invitedRequest.filter({ request -> Bool in
                    if request.accepted == 0 {
                        
                        return true
                    } else {
                        return false
                    }
                })
                
                for sender in invitedRequest {
                    
                    group.enter()
                    
                    UserManager.shared.fetchUserInfo(userID: sender.sender) { result in
                        
                        switch result {
                            
                        case .success(let senderInfo):
                            
                            self.senderInfo[sender.sender] = senderInfo
                                                                                    
                            group.leave()
                            
                        case .failure(let error):
                            
                            print("fetch sender info \(error)")
                            
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    self.invitedTableView.dataSource = self
                    self.invitedTableView.delegate = self
                    self.invitedTableView.reloadData()
                }
                
            case .failure(let error):
                print("fetchAllInvitation.failure: \(error)")
            }
        }
    }
    
    @objc func confirmedPressed(_ sender: UIButton!) {
        
        self.friendLists.append(invitedRequests[sender.tag].sender)
        
    print("confirm \(senderFriendLists)")
        
        self.senderFriendLists.append(invitedRequests[sender.tag].receiver)

        UserManager.shared.updateFriendList(friendLists: friendLists)
        
        UserManager.shared.updateOtherUserFriendList(sender: senderID, friendLists: senderFriendLists)

        InvitationManager.shared.updateInvitedStatus(sender: invitedRequests[sender.tag].sender)
        
        invitedRequests.remove(at: sender.tag)
        
        Toast.showSuccess(text: "成功加入好友")
    }
    
    @objc func notNowButtonPressed(_ sender: UIButton!) {
        
        InvitationManager.shared.deleteInvitedRequest(sender: invitedRequests[sender.tag].sender)
        
        invitedRequests.remove(at: sender.tag)
        
        Toast.showSuccess(text: "已取消")
    }
}

extension InvitationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invitedRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InvitedTableViewCell.identifier, for: indexPath
        ) as? InvitedTableViewCell else { fatalError("can not dequeue") }
                
        senderID = invitedRequests[indexPath.row].sender
                
        guard let userInfo = senderInfo[senderID] else { return cell }
        
        cell.confirmedButton.tag = indexPath.row
        
        cell.notNowButton.tag = indexPath.row
        
        cell.profileImageView.loadImage(userInfo.userImageURL, placeHolder: UIImage(systemName: "person.crop.circle"))
        
        cell.userName.text = userInfo.username
                            
        if invitedRequests[indexPath.row].accepted == 0 {

            cell.confirmedButton.addTarget(self, action: #selector(confirmedPressed(_:)), for: .touchUpInside)

            cell.notNowButton.addTarget(self, action: #selector(notNowButtonPressed(_:)), for: .touchUpInside)
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
