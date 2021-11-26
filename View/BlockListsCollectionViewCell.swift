//
//  BlockListsCollectionView.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/16.
//

import UIKit

class BlockListsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BlockListsCollectionViewCell"
    
    lazy var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage.system(.personPlacehloder)
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    lazy var friendName: UILabel = {
        
        let label = UILabel()
        label.text = "who are you"
        label.textColor = .black
        label.font = UIFont.regular(size: 17)
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProfileImageView()
        setupfriendNameLabel()
        
        profileImageView.layer.cornerRadius = 20
        
        contentView.backgroundColor = .D1
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentViewConfig()
        
        profileImageView.clipsToBounds = true
    }

    private func buttonConfig(_ button: UIButton) {
        
        button.titleLabel?.font = UIFont.regular(size: 15)
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
    
    private func contentViewConfig() {
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
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
}
