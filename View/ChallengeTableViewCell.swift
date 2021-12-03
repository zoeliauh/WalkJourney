//
//  ChallengeTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/7.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    
    lazy var challengeImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage.asset(.challengeIcon)
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    lazy var dateLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.regular(size: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepsLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.regular(size: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var detailButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage.asset(.nextIcon), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        setupLogoImageView()
        setupDateLabel()
        setupStepsLabel()
        setupDetailButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
}

// MARK: - UI design
extension ChallengeTableViewCell {
    
    private func setupLogoImageView() {
        
        contentView.addSubview(challengeImageView)
        
        challengeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            challengeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            challengeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            challengeImageView.heightAnchor.constraint(equalToConstant: 30),
            challengeImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func setupDateLabel() {
        
        contentView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            dateLabel.leadingAnchor.constraint(equalTo: challengeImageView.leadingAnchor, constant: 70),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            dateLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupStepsLabel() {
        
        contentView.addSubview(stepsLabel)
        
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            stepsLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20),
            stepsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
    }
    
    private func setupDetailButton() {
        
        contentView.addSubview(detailButton)
        
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            detailButton.heightAnchor.constraint(equalToConstant: 30),
            detailButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
