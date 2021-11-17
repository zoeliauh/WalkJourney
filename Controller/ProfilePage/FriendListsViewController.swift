//
//  FriendListsViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/13.
//

import UIKit

class FriendListsViewController: UIViewController {
    
    lazy var friendListsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.size.width
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: ((width - 44) / 3), height: width / 3 * 1.5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(FriendListsCollectionViewCell.self,
                                forCellWithReuseIdentifier: FriendListsCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    var myID = UserManager.shared.uid
    
    var friendLists: [String] = []
    
    var friendInfo: [String: User] = [:]
    
    var friendID: String = ""
    
    var blockLists: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFriendList()
        
        setupCollectionView()
    }
    
    func fetchFriendList() {
        
        guard let myID = myID else { return }
        
        UserManager.shared.fetchUserInfo(uesrID: myID) { [self] result in
            
            switch result {
                
            case .success(let friendList):
                
                let group = DispatchGroup()
                
//                guard let lists = friendList.friendLists else {
//                    return }
//
//                guard let blockLists = friendList.blockLists else {
//                    return }

                self.friendLists = friendList.friendLists ?? []
                
                self.blockLists = friendList.blockLists ?? []
                
                for friend in self.friendLists {
                    
                    group.enter()
                    
                    UserManager.shared.fetchUserInfo(uesrID: friend) { result in
                        
                        switch result {
                            
                        case .success(let friends):
                            
                            self.friendInfo[friend] = friends
                                                    
                            group.leave()
                            
                        case .failure(let error):
                            
                            print("fetcFriendData.failure: \(error)")
                            
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    friendListsCollectionView.dataSource = self
                    friendListsCollectionView.delegate = self
                    friendListsCollectionView.reloadData()
                }
                    
            case .failure(let error):
                print("fetchFriendList.failure: \(error)")
            }
        }
    }
    
    @objc func challengeButtonPressed() {
        
        Toast.showSuccess(text: "已發出挑戰")
    }
}

extension FriendListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return friendLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FriendListsCollectionViewCell.identifier,
            for: indexPath
        ) as? FriendListsCollectionViewCell else {
            fatalError("can not dequeue collectionViewCell")
        }
        
        friendID = friendLists[indexPath.row]
        
        guard let userInfo = friendInfo[friendID] else { return cell }

        cell.profileImageView.loadImage(userInfo.userImageURL)
        
        cell.friendName.text = userInfo.username
        
        cell.challengeButton.addTarget(self, action: #selector(challengeButtonPressed), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath,
                        point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let blockAction = UIAction(
                
                title: "封鎖使用者", image: UIImage(systemName: "person.fill.xmark"),
                
                identifier: nil,
                
                discoverabilityTitle: nil, attributes: .destructive) { [self]_ in
                    
                    let controller = UIAlertController(title: "",
                                                       message: "確定要將此人加入黑名單嗎?\n一但加入即無法取消唷",
                                                       preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "確定", style: .default) { _ in
                                                
                        self.blockLists.append(friendLists[indexPath.row])
                        
                        UserManager.shared.updateBlockList(blockLists: blockLists)
                        
                        friendLists.remove(at: indexPath.row)
                        
                        UserManager.shared.updateFriendList(friendLists: friendLists)
                        
                        friendListsCollectionView.reloadData()
                    }
                    
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    
                    controller.addAction(okAction)
                    
                    controller.addAction(cancelAction)
                    
                    present(controller, animated: true, completion: nil)
                }
                    
                    return UIMenu(title: "", image: nil, identifier: nil,
                                  
                                  options: UIMenu.Options.displayInline, children: [blockAction]
                    )
                }
            
            return config
        }
    
    func setupCollectionView() {
        
        view.addSubview(friendListsCollectionView)
        
        friendListsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            friendListsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            friendListsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            friendListsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            friendListsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
