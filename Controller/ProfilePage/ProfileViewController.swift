//
//  ProfileViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import FirebaseAuth
import Firebase
import SwiftUI

class ProfileViewController: UIViewController {
    
     enum LabelType: Int {
        
        case rank = 0
        
        case friendList = 1
        
        case challenge = 2
    }
    
    var labels: [UILabel] {
        
        return [rankLabel, friendListLabel, challengeLabel]
    }
    
    let invitation = ["Ed", "樂清", "Astrid"]
    
    lazy var nameTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.text = nil
        textfield.placeholder = "輸入使用者名稱"
        textfield.font = UIFont.kleeOneRegular(ofSize: 30)
        textfield.textAlignment = .left
        textfield.textColor = .black
    
       return textfield
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
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.loadImage(eventUrlString, placeHolder: UIImage(systemName: "plus.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
       return imageView
    }()
    
    lazy var newPhotoButton: UIButton = {
        let newPhotoButton = UIButton(type: .system)
        newPhotoButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        newPhotoButton.tintColor = UIColor.darkGray
        newPhotoButton.layer.masksToBounds = true
        newPhotoButton.addTarget(self, action: #selector(newPhoto), for: .touchUpInside)
        return newPhotoButton
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
    
    lazy var rankLabel: UILabel = {
        
        let label = UILabel()
        label.text = "本日排名"
        label.font = UIFont.kleeOneRegular(ofSize: 20)
        label.textColor = .black
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
        label.textColor = .lightGray
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
    
    var eventUrlString = String()
    
    var profilePhoto = UIImage() {
        
        didSet {
            
            profileImageView.image = profilePhoto
            
            self.reloadInputViews()
        }
    }
    
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
        
        self.navigationController?.isNavigationBarHidden = true
        
        setupNameTextField()
        setupSearchButton()
        setupSettingButton()
        setupRankImageView()
        setupProfileImageView()
        setupLabels()
        setupChallengeInvitationTableView()
        setupNewPhotoButton()
        
        fetchUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabbarHeight = self.tabBarController?.tabBar.frame.height
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        profileImageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func newPhoto() {
        showImagePickerControllerActionSheet()
    }
    
    func fetchUserInfo() {
        
        guard let uid = UserManager.shared.uid else { return }
        
        UserManager.shared.fetchUserInfo(uesrID: uid) { [weak self] result in
            
            switch result {
                
            case .success(let userInfo):
                
                self?.userInfo = userInfo
                print(userInfo)
                
                self?.nameTextField.text = userInfo.username
                
                self?.profileImageView.loadImage(userInfo.userImageURL)
                
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
 
    // MARK: UI design
    private func setupNameTextField() {
        
        view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        nameTextField.addTarget(self, action: #selector(setupEditNameTextField), for: .editingDidEnd)
    }
    
    @objc private func setupEditNameTextField(_ sender: UITextField) {
        
        guard let userName = sender.text else { return }
        
        guard let uid = UserManager.shared.uid else { return }
        
        UserManager.shared.updateUserInfo(userID: uid, url: nil, username: userName)
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

    private func setupProfileImageView() {
        
        view.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: rankImageView.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    private func setupNewPhotoButton() {
        view.addSubview(newPhotoButton)
        
        newPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newPhotoButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 6),
            newPhotoButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 3),
            newPhotoButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 0.4),
            newPhotoButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 0.4)
        ])
    }
    
    func setupRankImageView() {
        
        view.addSubview(rankImageView)
        
        rankImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            rankImageView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            rankImageView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 5),
            rankImageView.widthAnchor.constraint(equalToConstant: 24),
            rankImageView.heightAnchor.constraint(equalToConstant: 24)
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
            rankLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            
            friendListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            friendListLabel.topAnchor.constraint(equalTo: rankLabel.topAnchor),
            friendListLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3),
            
            challengeLabel.topAnchor.constraint(equalTo: rankLabel.topAnchor),
            challengeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            challengeLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 3)
        ])
        
        labelClicked()
    }
    
    private func labelClicked() {
        
        labels.forEach {
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelAction(_:)))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tap)
        }
    }
        
    @objc func labelAction(_ gesture: UITapGestureRecognizer) {
        
        let label = gesture.view as? UILabel

        guard let label = label else { return }
        
        if label.text == "本日排名" {
            clickRankLabel(type: .rank)
        }
        
        if label.text == "好友名單" {
            clickRankLabel(type: .friendList)
        }
        
        if label.text == "挑戰邀請" {
            clickRankLabel(type: .challenge)
        }
    }
    
    func clickRankLabel(type: LabelType) {
            
        switch type {
            
        case .rank:
            resetLabelsColor()
            rankLabel.textColor = UIColor.black
            
        case .friendList:
            resetLabelsColor()
            friendListLabel.textColor = UIColor.black
            
        case .challenge:
            resetLabelsColor()
            challengeLabel.textColor = UIColor.black
        }
    }
    
    func resetLabelsColor() {
        labels.forEach {
            $0.textColor = UIColor.lightGray
        }
    }
    
    @objc func clickFriendListLabel() {
        
        print("time to clickFriend")
    }
    
    @objc func clickChallengeLabel() {
        
        print("time to clickChallenge")
    }
    
    // MARK: - clickLabel
        
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let actionSheet = UIAlertController(title: "Attach Photo", message: "where would you like to attach a photo from", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        profilePhoto = editedImage
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        profilePhoto = originalImage
        
        guard let imageData = editedImage.jpegData(compressionQuality: 0.25) else {
            return
        }
        
        let uniqueString = NSUUID().uuidString
            
        storage.child("profileImage/\(uniqueString)").putData(imageData, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self.storage.child("profileImage/\(uniqueString)").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self.eventUrlString = urlString
                UserDefaults.standard.set(urlString, forKey: "url")
                
                guard let uid = UserManager.shared.uid else { return }
                
                UserManager.shared.updateUserInfo(userID: uid, url: urlString, username: nil)
                
                })
            }
        }
    }
