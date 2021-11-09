//
//  ProfileViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import FirebaseAuth
import Lottie

class ProfileViewController: UIViewController {
    
    let invitation = ["Ed", "樂清", "Astrid"]
    
    lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Zoe"
        label.font = UIFont.kleeOneRegular(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .left
       return label
    }()
    
    lazy var searchButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "magnifyingGlass"), for: .normal)
        return button
    }()
    
    lazy var settingButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "settingIcon"), for: .normal)
        return button
    }()
    
    lazy var profileBackGroundImageView: UIImageView = {
        
        let imageView = UIImageView()
//        imageView.backgroundColor = .systemGray6
        imageView.image = UIImage(named: "placeholder")
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
       return imageView
    }()
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.layer.cornerRadius = 35
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
       return imageView
    }()
    
    // need to be stack view??
    lazy var rankImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.clipsToBounds = true
       return imageView
    }()
    
    lazy var challengeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "friends_invitation"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(funnyMapGame(_:)), for: .touchUpInside)
        return button
    }()
    
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
    
    lazy var animationView: AnimationView = {
            
            var animationView = AnimationView()
            animationView = .init(name: "profile_lottie")
            animationView.animationSpeed = 1
            return animationView
    }()
    
    lazy var rankLabel: UILabel = {
        
        let label = UILabel()
        label.text = "本日排名"
        label.font = UIFont.kleeOneRegular(ofSize: 20)
        label.textColor = .lightGray
        label.textAlignment = .center
       return label
    }()
    
    lazy var friendListLabel: UILabel = {
        
        let label = UILabel()
        label.text = "好友名單"
        label.font = UIFont.kleeOneRegular(ofSize: 20)
        label.textColor = .lightGray
        label.textAlignment = .center
       return label
    }()
    
    lazy var challengeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "挑戰邀請"
        label.font = UIFont.kleeOneRegular(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center
       return label
    }()
    
    lazy var challengeInviteTableView: UITableView = {
        
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(
            ChallengeInvitationTableViewCell.self,
            forCellReuseIdentifier: ChallengeInvitationTableViewCell.identifier
        )
        table.reloadData()

        return table
    }()
    
    var tabbarHeight: CGFloat? = 0.0
    
    var userInfo: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
        
        self.navigationController?.isNavigationBarHidden = true
        
        setupNameLabel()
        setupSearchButton()
        setupSettingButton()
        setupProfileBackGroundImageView()
        setupProfileImageView()
        setupRankImageView()
//        setupChallengeButton()
        setupLabels()
        setupChallengeInvitationTableView()
        
        fetchUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        tabbarHeight = self.tabBarController?.tabBar.frame.height
//        setupLogoutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func fetchUserInfo() {
        
        guard let uid = UserManager.shared.uid else { return }
        
        UserManager.shared.fetchUserInfo(uesrID: uid) { [weak self] result in
            
            switch result {
                
            case .success(let userInfo):
                
                self?.userInfo = userInfo
                print(userInfo)
                
                self?.nameLabel.text = userInfo.username
                
            case .failure(let error):
                
                print("fetchStepsData.failure: \(error)")
            }
        }
    }
    
    @objc func settingButtonPressed(_ sender: UIButton) {
        
        guard let settingVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "SettingVC"
        ) as? SettingViewController else { return }
                        
        self.present(settingVC, animated: true, completion: nil)
        
        print("done")
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
    
    // MARK: UI design
    private func setupNameLabel() {
        
        view.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameLabel.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    private func setupSearchButton() {
        
        view.addSubview(searchButton)
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            searchButton.widthAnchor.constraint(equalToConstant: 20),
            searchButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupSettingButton() {
        
        view.addSubview(settingButton)
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            settingButton.widthAnchor.constraint(equalToConstant: 20),
            settingButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        settingButton.addTarget(self, action: #selector(settingButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupProfileBackGroundImageView() {
        
        view.addSubview(profileBackGroundImageView)
        
        profileBackGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            profileBackGroundImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            profileBackGroundImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            profileBackGroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            profileBackGroundImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupProfileImageView() {
        
        view.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileBackGroundImageView.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func setupRankImageView() {
        
        view.addSubview(rankImageView)
        
        rankImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            rankImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            rankImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            rankImageView.widthAnchor.constraint(equalToConstant: 24),
            rankImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupChallengeButton() {
        
        view.addSubview(challengeButton)
        
        challengeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            challengeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            challengeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            challengeButton.widthAnchor.constraint(equalToConstant: 50),
            challengeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupLabels() {
        
        view.addSubview(rankLabel)
        view.addSubview(friendListLabel)
        view.addSubview(challengeLabel)
        
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        friendListLabel.translatesAutoresizingMaskIntoConstraints = false
        challengeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            rankLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rankLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
//            rankLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            rankLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            
            friendListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            friendListLabel.topAnchor.constraint(equalTo: rankLabel.topAnchor),
            friendListLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            
            challengeLabel.topAnchor.constraint(equalTo: rankLabel.topAnchor),
            challengeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            challengeLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3)
        ])
    }
        
    private func setupChallengeInvitationTableView() {
        
        view.addSubview(challengeInviteTableView)
        
        challengeInviteTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            challengeInviteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            challengeInviteTableView.topAnchor.constraint(equalTo: rankLabel.bottomAnchor, constant: 20),
            challengeInviteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            challengeInviteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLogoutButton() {
        
        view.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabbarHeight ?? 49.0) - 10),
            logoutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupLottie() {
            
            view.addSubview(animationView)
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
            
                animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20)
            ])
            animationView.loopMode = .loop
            animationView.play()
        }
    
    @objc func funnyMapGame(_ sender: UIButton!) {
        guard let funnyMapPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "FunnyMapPage"
        ) as? FunnyMapViewController else { return }

        self.navigationController?.pushViewController(funnyMapPagevc, animated: true)
    }
}

// MARK: - TableViewDataSource, TableViewDelegate
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return invitation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChallengeInvitationTableViewCell.identifier,
            for: indexPath
        ) as? ChallengeInvitationTableViewCell else { fatalError("can not dequeue settingTableViewCell") }
        
        cell.nameLabel.text = invitation[indexPath.row]
        
        cell.chellangeButton.addTarget(self, action: #selector(funnyMapGame(_:)), for: .touchUpInside)
        
        return cell
    }
}
