//
//  FriendListsViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/13.
//

import UIKit

class FriendListsViewController: UIViewController {
    
    lazy var friendListCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.size.width
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: ((width - 44) / 3), height: width / 3 * 1.5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FriendListsCollectionViewCell.self,
                                forCellWithReuseIdentifier: FriendListsCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var myID = UserManager.shared.uid
    
    var friendList: [String] = []
    
    var friendInfo: [String: User] = [:]
        
    var blockList: [String] = []
    
    // user info
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchFriendList()
        
        setupCollectionView()
    }
    
    func fetchFriendList() {
        
        guard let myID = myID else { return }
        
        UserManager.shared.fetchUserInfo(userID: myID) { [weak self] result in
            
            switch result {
                
            case .success(let friendList):
                
                let group = DispatchGroup()
                
                self?.friendList = friendList.friendLists ?? []
                
                self?.blockList = friendList.blockLists ?? []
                
                for friend in self?.friendList ?? [] {
                    
                    group.enter()
                    
                    UserManager.shared.fetchUserInfo(userID: friend) { result in
                        
                        switch result {
                            
                        case .success(let friends):
                            
                            self?.friendInfo[friend] = friends
                            
                            group.leave()
                            
                        case .failure(let error):
                            
                            print("fetcFriendData.failure: \(error)")
                            
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    self?.friendListCollectionView.dataSource = self
                    self?.friendListCollectionView.delegate = self
                    self?.friendListCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("fetchFriendList.failure: \(error)")
            }
        }
    }
    
    @objc func challengeButtonPressed(_ sender: UIButton) {
        
        Toast.showSuccess(text: "建置中")
        
        guard let funnyMapPageVC = UIStoryboard.position.instantiateViewController(
            withIdentifier: String(describing: FunnyMapViewController.self)
        ) as? FunnyMapViewController else { return }
        
        self.navigationController?.pushViewController(funnyMapPageVC, animated: true)
    }
}

extension FriendListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return friendList.count
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
        
        let friendID = friendList[indexPath.row]
        
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
                
                title: "封鎖使用者", image: UIImage.system(.personFillXMark),
                
                identifier: nil,
                
                discoverabilityTitle: nil, attributes: .destructive) { [weak self]_ in
                    
                    self?.present(.confirmationAlert(
                        title: "", message: "確定要將此人加入黑名單嗎?\n一但加入即無法取消唷",
                        preferredStyle: .alert,
                        actions: [UIAlertAction.addAction(
                            title: String.confirmed,
                            style: .default,
                            handler: { [weak self] _ in
                            
                            self?.blockList.append(self?.friendList[indexPath.row] ?? "")
                            
                            UserManager.shared.updateBlockList(blockLists: self?.blockList ?? [])
                            
                            self?.friendList.remove(at: indexPath.row)
                            
                            UserManager.shared.updateFriendList(friendLists: self?.friendList ?? [])
                            
                            self?.friendListCollectionView.reloadData()
                            
                        }), UIAlertAction.addAction(title: String.cancel, style: .destructive, handler: nil)
                                  
                                 ]), animated: true, completion: nil)
                }
            
            return UIMenu(title: "", image: nil, identifier: nil,
                          
                          options: UIMenu.Options.displayInline, children: [blockAction]
            )
        }
        
        return config
    }
    
    func setupCollectionView() {
        
        view.addSubview(friendListCollectionView)
        
        friendListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            friendListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            friendListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            friendListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            friendListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
