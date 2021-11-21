//
//  FriendListsCollectionViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/13.
//

import UIKit

class FriendListsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FriendListsCollectionViewCell"
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        return imageView
    }()
    
    lazy var friendName: UILabel = {
        
        let label = UILabel()
        label.text = "who are you"
        label.textColor = .black
        label.font = UIFont.kleeOneRegular(ofSize: 17)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    lazy var challengeButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("發出挑戰", for: .normal)
        buttonConfig(button)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProfileImageView()
        setupfriendNameLabel()
        setupChallengeButton()
        
        contentView.backgroundColor = .C1
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
    
    private func buttonConfig(_ button: UIButton) {
        
        button.titleLabel?.font = UIFont.kleeOneRegular(ofSize: 15)
        button.backgroundColor = UIColor.C4
        button.layer.cornerRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 2.0
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.layoutIfNeeded()
    }
    
    // MARK: - UI design
    private func setupProfileImageView() {
        
        contentView.addSubview(profileImageView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: contentView.frame.width * 0.7),
            profileImageView.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.7)
        ])
    }
    
    private func setupfriendNameLabel() {
        
        contentView.addSubview(friendName)
        
        friendName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            friendName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            friendName.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor)
        ])
    }
    
    private func setupChallengeButton() {
        
        contentView.addSubview(challengeButton)
        
        challengeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            challengeButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            challengeButton.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 10),
            challengeButton.heightAnchor.constraint(equalToConstant: 30),
            challengeButton.widthAnchor.constraint(equalToConstant: contentView.frame.width * 0.7)
        ])
    }
    
}
