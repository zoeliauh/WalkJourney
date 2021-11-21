//
//  BlockListsViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/13.
//

import UIKit

class BlockListsViewController: UIViewController {
    
    lazy var blockListsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let width = view.frame.size.width
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: ((width - 44) / 3), height: width / 3 * 1.2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(BlockListsCollectionViewCell.self,
                                forCellWithReuseIdentifier: BlockListsCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var myID = UserManager.shared.uid
    
    var blockLists: [String] = []
    
    var blockInfo: [String: User] = [:]
    
    var blockID: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBlockList()
        
        setupCollectionView()
    }
    
    func fetchBlockList() {
        
        guard let myID = myID else { return }
        
        UserManager.shared.fetchUserInfo(uesrID: myID) { [self] result in
            
            switch result {
                
            case .success(let blockList):
                
                let group = DispatchGroup()
                
                guard let lists = blockList.blockLists else { return }
                
                self.blockLists = lists
                
                for block in self.blockLists {
                    
                    group.enter()
                    
                    UserManager.shared.fetchUserInfo(uesrID: block) { result in
                        
                        switch result {
                            
                        case .success(let blockFriends):
                            
                            self.blockInfo[block] = blockFriends
                            
                            print("friends are \(blockFriends)")
                        
                            group.leave()
                            
                        case .failure(let error):
                            print("fetcBlockFriendData.failure: \(error)")
                            
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    blockListsCollectionView.dataSource = self
                    blockListsCollectionView.delegate = self
                    blockListsCollectionView.reloadData()
                }
                    
            case .failure(let error):
                print("fetchBlockList.failure: \(error)")
            }
        }
    }
}

extension BlockListsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return blockLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BlockListsCollectionViewCell.identifier,
            for: indexPath
        ) as? BlockListsCollectionViewCell else {
            fatalError("can not dequeue collectionViewCell")
        }
        
        blockID = blockLists[indexPath.row]
        
        guard let userInfo = blockInfo[blockID] else { return cell }

        cell.profileImageView.loadImage(userInfo.userImageURL)
        
        cell.friendName.text = userInfo.username
        
        return cell
    }
    
    func setupCollectionView() {
        
        view.addSubview(blockListsCollectionView)
        
        blockListsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            blockListsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            blockListsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            blockListsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            blockListsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
