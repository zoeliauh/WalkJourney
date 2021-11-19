//
//  GalleryViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/18.
//

import UIKit

class GalleryViewController: UIViewController {
    
    lazy var gpsArtTableView: UITableView = {
        
        let table = UITableView()
        table.rowHeight = UITableView.automaticDimension
        table.showsVerticalScrollIndicator = false
        table.register(GPSArtTableViewCell.self, forCellReuseIdentifier: GPSArtTableViewCell.identifier)
        table.reloadData()

        return table
    }()
    
    var publicPosts: [PublicPost] = [] {
        
        didSet {
            
            gpsArtTableView.reloadData()
        }
    }
    
    var posterLists: [String] = []
    
    var posterInfo: [String: User] = [:]
    
    var posterID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
                    
        setNavigationBar()
        
        fetchAllPublicPostInfo()

        setupgpsArtTableView()
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
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font,
                                                                       NSAttributedString.Key.foregroundColor: UIColor.black]
        }
    
    private func fetchAllPublicPostInfo() {
        
        PublicPostManager.shared.fetchAllPublicPostInfo { [self] result in
            
            switch result {
            
            case .success(let publicPosts):
                
                let group = DispatchGroup()
                                
                self.publicPosts = publicPosts
                
                self.publicPosts.sort { $0.createdTime ?? 0 > $1.createdTime ?? 0 }
                
                for post in publicPosts {
                    
                    group.enter()
                    
                    UserManager.shared.fetchUserInfo(uesrID: post.uid) { result in
                        
                        switch result {
                            
                        case .success(let posterInfo):
                            
                            posterID = post.uid
                            
                            self.posterInfo[posterID] = posterInfo
                                                        
                            print("posterInfo is \(posterInfo)")
                            
                            group.leave()
                            
                        case .failure(let error):
                            
                            print("fetch sender info \(error)")
                            
                            group.leave()
                        }
                    }
                }
                group.notify(queue: .main) {
                    
                    self.gpsArtTableView.dataSource = self
                    self.gpsArtTableView.delegate = self
                    self.gpsArtTableView.reloadData()
                }
            case .failure(let error):
                
                print("fetcFriendData.failure: \(error)")
            }
        }
    }
}

// MARK: - tableViewDelegate, tableViewDataSource
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
                
        cell.profileImageView.loadImage(userInfo.userImageURL, placeHolder: UIImage(systemName: "person.crop.circle"))
                        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let navZoomInvc = UIStoryboard.gallery.instantiateViewController(
            withIdentifier: "ZoomIn"
        ) as? ZoomInViewController else { return }
        
        navZoomInvc.screenshotURL = publicPosts[indexPath.row].screenshotURL
    
        navigationController?.pushViewController(navZoomInvc, animated: true)
        
        print("navZoomInvc")
        
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
}
