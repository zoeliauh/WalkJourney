//
//  GalleryViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/18.
//

import UIKit
import Lottie
import Kingfisher

class GalleryViewController: UIViewController {
    
    lazy var gpsArtTableView: UITableView = {
        
        let table = UITableView()
        table.rowHeight = UITableView.automaticDimension
        table.showsVerticalScrollIndicator = false
        table.register(GPSArtTableViewCell.self, forCellReuseIdentifier: GPSArtTableViewCell.identifier)
        table.reloadData()
        
        return table
    }()
    
    lazy var animationView: AnimationView = {
        
        var animationView = AnimationView()
        animationView = .init(name: String.loading)
        animationView.animationSpeed = 1
        animationView.layoutIfNeeded()
        return animationView
    }()
    
    var publicPosts: [PublicPost] = [] {
        
        didSet {
            
            gpsArtTableView.reloadData()
        }
    }
    
    var myID = UserManager.shared.uid
    
    var posterLists: [String] = []
    
    var posterInfo: [String: User] = [:]
    
    var posterID: String = ""
    
    var blockLists: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
        
        setNavigationBar()
        
        setupgpsArtTableView()
        
        setupLottie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllPublicPostInfo()
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "社群"
        navigationController?.navigationBar.barTintColor = UIColor.black
        let font = UIFont.boldSystemFont(ofSize: 25)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    func deletePublicPost(indexPath: IndexPath) {
        
        guard let createdTime = publicPosts[indexPath.row].createdTime else { return }
        
        if UserManager.shared.uid == publicPosts[indexPath.row].uid {
            
            PublicPostManager.shared.deletePersonalPost(createdTime: createdTime)
            publicPosts.remove(at: indexPath.row)
            gpsArtTableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            
            present(.confirmationAlert(
                title: "", message: "只能刪除自己的貼文",
                preferredStyle: .alert,
                actions: [UIAlertAction.addAction(
                    title: String.confirmed, style: .default, handler: nil)]), animated: true, completion: nil)
        }
    }
    
    private func fetchAllPublicPostInfo() {
        
        guard let myID = myID else { return }
        
        UserManager.shared.fetchUserInfo(userID: myID) { [weak self] result in
            
            switch result {
                
            case .success(let blockList):
                
                self?.blockLists = blockList.blockLists ?? []
                
                PublicPostManager.shared.fetchAllPublicPostInfo { [weak self] result in
                    
                    switch result {
                        
                    case .success(let publicPosts):
                        
                        let group = DispatchGroup()
                        
                        self?.publicPosts = []
                        
                        for index in publicPosts where self?.blockLists.contains(index.uid) == false {
                            
                            self?.publicPosts.append(index)
                            
                            self?.publicPosts.sort { $0.createdTime ?? 0 > $1.createdTime ?? 0 }
                        }
                        
                        for post in publicPosts {
                            
                            group.enter()
                            
                            UserManager.shared.fetchUserInfo(userID: post.uid) { [weak self] result in
                                
                                switch result {
                                    
                                case .success(let posterInfo):
                                    
                                    self?.posterID = post.uid
                                    
                                    self?.posterInfo[post.uid] = posterInfo
                                    
                                    group.leave()
                                    
                                case .failure(let error):
                                    
                                    print("fetch sender info \(error)")
                                    
                                    group.leave()
                                }
                            }
                        }
                        group.notify(queue: .main) {
                            self?.gpsArtTableView.dataSource = self
                            self?.gpsArtTableView.delegate = self
                            self?.gpsArtTableView.reloadData()
                            self?.animationView.removeFromSuperview()
                        }
                        
                    case .failure(let error):
                        
                        print("fetcFriendData.failure: \(error)")
                    }
                }
                
            case .failure(let error):
                print("fetchBlockList.failure: \(error)")
            }
        }
    }
}

extension GalleryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return publicPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GPSArtTableViewCell.identifier, for: indexPath
        ) as? GPSArtTableViewCell else { fatalError("can not dequeue gpsAtrCell") }
        
        cell.gpsImageView.loadImage(publicPosts[indexPath.row].screenshotURL, placeHolder: nil)
        
        cell.postTimeLabel.text = Date.dateFormatter.string(
            from: Date.init(milliseconds: publicPosts[indexPath.row].createdTime ?? Int64(0.0)
                           ))
        posterID = publicPosts[indexPath.row].uid
        
        guard let userInfo = posterInfo[posterID] else { return cell }
        
        cell.userNameLabel.text = userInfo.username
        
        cell.profileImageView.loadImage(
            userInfo.userImageURL, placeHolder: UIImage(systemName: "person.crop.circle"))
        
        cell.selectionStyle = .none
        
        self.animationView.removeFromSuperview()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            tableView.beginUpdates()
            
            deletePublicPost(indexPath: indexPath)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let blockAction = UIAction(
                
                title: "封鎖使用者", image: UIImage.system(.personFillXMark),
                
                identifier: nil,
                
                discoverabilityTitle: nil, attributes: .destructive) { [weak self]_ in
                    
                    self?.present(.confirmationAlert(
                        title: "", message: "確定要將此人加入黑名單嗎?\n一但加入即無法取消唷",
                        preferredStyle: .alert, actions: [
                            UIAlertAction.addAction(
                                title: String.confirmed, style: .default,
                                handler: { [weak self] _ in
                                    
                                    self?.blockLists.append(self?.publicPosts[indexPath.row].uid ?? "")
                                    UserManager.shared.updateBlockList(blockLists: self?.blockLists ?? [])
                                    self?.gpsArtTableView.reloadData()
                                    
                                }), UIAlertAction.addAction(
                                    title: String.cancel, style: .destructive, handler: nil)
                        ]), animated: true, completion: nil)
                }
            
            return UIMenu(title: "", image: nil, identifier: nil,
                          
                          options: UIMenu.Options.displayInline, children: [blockAction]
            )
        }
        
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let navZoomInvc = UIStoryboard.gallery.instantiateViewController(
            withIdentifier: String(describing: ZoomInViewController.self)
        ) as? ZoomInViewController else { return }
        
        navZoomInvc.screenshotURL = publicPosts[indexPath.row].screenshotURL
        
        navigationController?.pushViewController(navZoomInvc, animated: true)
    }
}

// MARK: - UI design
extension GalleryViewController {
    
    private func setupgpsArtTableView() {
        
        view.addSubview(gpsArtTableView)
        
        gpsArtTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            gpsArtTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            gpsArtTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gpsArtTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            gpsArtTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupLottie() {
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        animationView.play()
    }
}
