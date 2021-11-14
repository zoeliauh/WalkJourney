//
//  ProfileViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    lazy var nameTextField: UITextField = {
        
        let textfield = UITextField()
        textfield.text = nil
        textfield.placeholder = "輸入使用者名稱"
        textfield.font = UIFont.kleeOneRegular(ofSize: 25)
        textfield.textAlignment = .left
        textfield.textColor = .black
        textfield.layer.cornerRadius = 20
        textfield.isUserInteractionEnabled = false
        
        return textfield
    }()
    
    lazy var editButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
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
    
    var tabbarHeight: CGFloat? = 0.0
    
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
    
    var friendListsArray: [String] = []
    
    var blockListsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
        let searchController = UISearchController(searchResultsController: UserSearchViewController())
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = "請搜尋使用者名稱"
        
        fetchUserInfo()
//        fetchAllUserInfo()
        
        setupNameTextField()
        setupEditButton()
//        setupSearchButton()
        setupSettingButton()
        setupRankImageView()
        setupProfileImageView()
        setupNewPhotoButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabbarHeight = self.tabBarController?.tabBar.frame.height
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        profileImageView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.isNavigationBarHidden = true
        
        fetchUserInfo()
    }
    
    @objc func newPhoto() {
        showImagePickerControllerActionSheet()
    }
    
    // fetch certain user Data
    func fetchUserInfo() {
        
        guard let uid = UserManager.shared.uid else { return }
        
        UserManager.shared.fetchUserInfo(uesrID: uid) { [weak self] result in
            
            switch result {
                
            case .success(let userInfo):
                
                self?.userInfo = userInfo
                
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
    }
    
    @objc private func setupEditNameTextField(_ sender: UITextField) {
        
        guard let userName = sender.text else { return }
        
        guard let uid = UserManager.shared.uid else { return }
        
        UserManager.shared.updateUserInfo(userID: uid, url: nil, username: userName)
        
        nameTextFieldIsEnable = false
    }
    
    @objc func funnyMapGame(_ sender: UIButton!) {
        guard let funnyMapPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "FunnyMapPage"
        ) as? FunnyMapViewController else { return }
        
        self.navigationController?.pushViewController(funnyMapPagevc, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let actionSheet = UIAlertController(
            title: "Attach Photo",
            message: "where would you like to attach a photo from",
            preferredStyle: .actionSheet
        )
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

// MARK: - UISearchResultsUpdating
extension ProfileViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
                
        guard let resultsVC = searchController.searchResultsController as? UserSearchViewController else { return }
        
        resultsVC.shouldShowSearchResults = true
        
        resultsVC.filteredUserInfo = resultsVC.allUserInfo.filter({
            
            guard let username = $0.username else { return true }
            
            return username.lowercased().prefix(text.count) == text.lowercased()
        })
        
        resultsVC.userSearchTableView.reloadData()
    }
}

extension ProfileViewController {
    
    private func setupNameTextField() {
        
        view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.width / 2)
        ])
        
        nameTextField.addTarget(self, action: #selector(setupEditNameTextField), for: .editingDidEnd)
    }
    
    private func setupEditButton() {
        
        view.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            editButton.widthAnchor.constraint(equalToConstant: 20),
            editButton.heightAnchor.constraint(equalToConstant: 20)
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
            
            settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
}
