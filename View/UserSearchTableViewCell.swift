//
//  UserSearchTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/12.
//

import UIKit

class UserSearchTableViewCell: UITableViewCell {
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.loadImage(UserManager.shared.uid, placeHolder: UIImage.system(.personPlacehloder))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.regular(size: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addFriendButton: UIButton = {
        
        let button = UIButton()
        button.setTitle(String.addFriend, for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 10)
        return button
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        setupProfileImageView()
        setupUserNameLabel()
        setupAddFriendButton()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
}

// MARK: - UI design
extension UserSearchTableViewCell {
    
    private func setupProfileImageView() {
        
        contentView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupUserNameLabel() {
        
        contentView.addSubview(userNameLabel)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            userNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            userNameLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func setupAddFriendButton() {
        
        contentView.addSubview(addFriendButton)
        
        addFriendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            addFriendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addFriendButton.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            addFriendButton.heightAnchor.constraint(equalToConstant: 30),
            addFriendButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
