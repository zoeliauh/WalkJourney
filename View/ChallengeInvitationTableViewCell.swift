//
//  ChallengeInvitationTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/8.
//

import UIKit

class ChallengeInvitationTableViewCell: UITableViewCell {

    lazy var chellangeButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "macpro.gen3.fill"), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.kleeOneRegular(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupNameLabel()
        setupChellangeButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }

    private func setupChellangeButton() {
        
        contentView.addSubview(chellangeButton)
        
        chellangeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            chellangeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            chellangeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            chellangeButton.heightAnchor.constraint(equalToConstant: 30),
            chellangeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupNameLabel() {
        
        contentView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}
