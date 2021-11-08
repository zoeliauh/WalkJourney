//
//  RecordTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/26.
//

import Foundation
import UIKit

class RecordTableViewCell: UITableViewCell {
    
    lazy var logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginIcon")
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    lazy var dateLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.kleeOneRegular(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepsLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.kleeOneRegular(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var detailButton: UIButton = {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: "Icon_next_24px"), for: .normal)
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
    
    private func setupLogoImageView() {
        
        contentView.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 30),
            logoImageView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func setupDateLabel() {
        
        contentView.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            dateLabel.leadingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: 70),
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
