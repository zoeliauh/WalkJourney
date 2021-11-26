//
//  ProfileViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import Lottie
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    lazy var nameTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.text = nil
        textfield.placeholder = String.enterTextFieldPlaceholder
        textfield.font = UIFont.regular(size: 22)
        textfield.textAlignment = .left
        textfield.textColor = .black
        textfield.layer.cornerRadius = 20
        textfield.isUserInteractionEnabled = false
        
        return textfield
    }()
    
    lazy var editButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.system(.pencil), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        return button
    }()
    
    lazy var settingButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.settingIcon), for: .normal)
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.loadImage(eventUrlString, placeHolder: UIImage.system(.personPlacehloder))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        return imageView
    }()
    
    lazy var newPhotoButton: UIButton = {
        let newPhotoButton = UIButton(type: .system)
        newPhotoButton.setImage(UIImage.system(.cameraFill), for: .normal)
        newPhotoButton.tintColor = UIColor.C1
        newPhotoButton.layer.masksToBounds = true
        newPhotoButton.addTarget(self, action: #selector(newPhoto), for: .touchUpInside)
        return newPhotoButton
    }()
    
    lazy var invitationButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle(String.friendInvited, for: .normal)
        button.addTarget(self, action: #selector(invitedPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var friendListsButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle(String.friendLists, for: .normal)
        button.addTarget(self, action: #selector(firendListsPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var blockLishButton: UIButton = {
        
        let button = UIButton()
        configButton(button)
        button.setTitle(String.blockLists, for: .normal)
        button.addTarget(self, action: #selector(blockListsPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var animationView: AnimationView = {
        
        var animationView = AnimationView()
        animationView = .init(name: String.loading)
        animationView.animationSpeed = 1
        animationView.layoutIfNeeded()
        return animationView
    }()
        
    var userInfo: User?
    
    var eventUrlString = String()
    
    var profilePhoto = UIImage() {
        
        didSet {
            
            profileImageView.image = profilePhoto
            
            self.reloadInputViews()
        }
    }
    
    var nameTextFieldIsEnable: Bool = true {
        
        didSet {
            nameTextField.isUserInteractionEnabled = nameTextFieldIsEnable ? true : false
            nameTextField.backgroundColor = nameTextFieldIsEnable ? UIColor.systemGray6 : UIColor.clear
        }
    }
    
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
        let searchController = UISearchController(searchResultsController: UserSearchViewController())
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = String.searchFriendName
        
        fetchUserInfo()
        setupProfileImageView()
        setupNameTextField()
        setupEditButton()
        setupSettingButton()
        setupNewPhotoButton()
        setupButtons()
        setupLottie()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        profileImageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        fetchUserInfo()
    }
    
    @objc func newPhoto() {
        showImagePickerControllerActionSheet()
    }
    
    func fetchUserInfo() {
                
        let group = DispatchGroup()
        
        guard let uid = UserManager.shared.uid else { return }
        
        UserManager.shared.fetchUserInfo(userID: uid) { [weak self] result in
            
            group.enter()
            
            switch result {
                
            case .success(let userInfo):
                
                self?.userInfo = userInfo
                
                self?.nameTextField.text = userInfo.username
                
                self?.profileImageView.loadImage(userInfo.userImageURL)
                
                group.leave()
                
            case .failure(let error):
                
                print("fetchStepsData.failure: \(error)")
                
                group.leave()
            }

            group.notify(queue: .main) {

                self?.animationView.removeFromSuperview()
            }
        }
    }
    
    private func configButton(_ button: UIButton) {
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.backgroundColor = UIColor.C4
        button.tintColor = UIColor.white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        button.layoutIfNeeded()
    }

    @objc func settingButtonPressed(_ sender: UIButton) {
        
        guard let settingVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: SettingViewController.self)
        ) as? SettingViewController else { return }
        
        self.present(settingVC, animated: true, completion: nil)
    }
    
    @objc private func setupEditNameTextField(_ sender: UITextField) {
        
        guard let userName = sender.text else { return }
        
        guard let uid = UserManager.shared.uid else { return }
        
        UserManager.shared.updateUserInfo(userID: uid, url: nil, username: userName)
        
        nameTextFieldIsEnable = false
    }
    
    @objc func invitedPressed(_ sender: UIButton) {
        
        guard let invitationVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: InvitationViewController.self)
        ) as? InvitationViewController else { return }

        self.present(invitationVC, animated: true, completion: nil)
    }
    
    @objc func firendListsPressed(_ sender: UIButton) {
        
        guard let firendListsVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: FriendListsViewController.self)
        ) as? FriendListsViewController else { return }

        self.present(firendListsVC, animated: true, completion: nil)
    }
    
    @objc func blockListsPressed(_ sender: UIButton) {
        
        guard let blockListsVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: BlockListsViewController.self)
        ) as? BlockListsViewController else { return }

        self.present(blockListsVC, animated: true, completion: nil)
    }
    
    @objc func funnyMapGame(_ sender: UIButton!) {
        guard let funnyMapPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: String(describing: FunnyMapViewController.self)
        ) as? FunnyMapViewController else { return }
        
        self.navigationController?.pushViewController(funnyMapPagevc, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let actionSheet = UIAlertController(
            title: String.cameraTitle,
            message: String.cameraMessage,
            preferredStyle: .actionSheet
        )
        actionSheet.addAction(UIAlertAction(title: String.camera, style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        if let popoverController = actionSheet.popoverPresentationController {

                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(
                        x: self.view.bounds.midX, y: self.view.bounds.midY,
                        width: 0, height: 0
                    )
            
                    popoverController.permittedArrowDirections = []
                }
        
        actionSheet.addAction(UIAlertAction(title: String.photoLibrary, style: .default, handler: { [weak self] _ in
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self?.present(picker, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: String.cancel, style: .cancel, handler: nil))
        
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

extension ProfileViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
                
        guard let resultsVC = searchController.searchResultsController as? UserSearchViewController else { return }
        
        resultsVC.shouldShowSearchResults = true
        
        resultsVC.filteredUserInfo = resultsVC.allUserInfo.filter({
            
            guard let username = $0.username else { return true }
            
            if username == userInfo?.username { return false }
            
            return username.lowercased().prefix(text.count) == text.lowercased()
        })
        
        resultsVC.userSearchTableView.reloadData()
    }
}

// MARK: - UI design
extension ProfileViewController {
    
    private func setupNameTextField() {
        
        view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nameTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        nameTextField.addTarget(self, action: #selector(setupEditNameTextField), for: .editingDidEnd)
    }
    
    private func setupEditButton() {
        
        view.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80)
        ])
        
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
    }
    
    @objc func editButtonPressed() {
        
        nameTextFieldIsEnable.toggle()
    }
    
    private func setupSettingButton() {
        
        view.addSubview(settingButton)
        
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            settingButton.widthAnchor.constraint(equalToConstant: 25),
            settingButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        settingButton.addTarget(self, action: #selector(settingButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func setupProfileImageView() {
        
        view.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
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
    
    private func setupButtons() {
        
        view.addSubview(invitationButton)
        view.addSubview(friendListsButton)
        view.addSubview(blockLishButton)
        
        invitationButton.translatesAutoresizingMaskIntoConstraints = false
        friendListsButton.translatesAutoresizingMaskIntoConstraints = false
        blockLishButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            invitationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            invitationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            invitationButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            invitationButton.heightAnchor.constraint(equalToConstant: 35),
            
            friendListsButton.widthAnchor.constraint(equalTo: invitationButton.widthAnchor),
            friendListsButton.heightAnchor.constraint(equalTo: invitationButton.heightAnchor),
            friendListsButton.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor),
            friendListsButton.topAnchor.constraint(equalTo: invitationButton.bottomAnchor, constant: 25),

            blockLishButton.widthAnchor.constraint(equalTo: invitationButton.widthAnchor),
            blockLishButton.heightAnchor.constraint(equalTo: invitationButton.heightAnchor),
            blockLishButton.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor),
            blockLishButton.topAnchor.constraint(equalTo: friendListsButton.bottomAnchor, constant: 25)
            
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
