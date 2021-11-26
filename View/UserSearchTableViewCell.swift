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
        button.backgroundColor = UIColor.C4
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layoutIfNeeded()

        return button
    }()
    
    var buttonIsEnable: Bool = true
    
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
        
        if buttonIsEnable {
            
            addFriendButton.isEnabled = true
            addFriendButton.backgroundColor = UIColor.C4
        } else {
            
            addFriendButton.isEnabled = false
            addFriendButton.backgroundColor = .lightGray
        }
        
    }
}
