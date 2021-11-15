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
    
    var friendName: [String] = []
    
    var friendProfileImage: [String] = [] 
    
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
                
                guard let lists = friendList.friendLists else { return }
                
                self.friendLists = lists
                
                for friend in self.friendLists {
                    
                    group.enter()
                    
                    UserManager.shared.fetchUserInfo(uesrID: friend) { result in
                        
                        switch result {
                            
                        case .success(let friends):
                            
                            guard let name = friends.username else { return }
                            
                            guard let profileURL = friends.userImageURL else { return }
                            
                            self.friendName.append(name)
                            
                            self.friendProfileImage.append(profileURL)
                        
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
        
        cell.profileImageView.loadImage(friendProfileImage[indexPath.row])

        cell.friendName.text = friendName[indexPath.row]
        
        return cell
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
