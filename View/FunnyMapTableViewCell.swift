//
//  FunnyMapTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit

class FunnyMapTableViewCell: UITableViewCell {
    
    lazy var shapeImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    lazy var goButton: UIButton = {
        
        let button = UIButton()
        button.setTitle(String.challengeStart, for: .normal)
        button.titleLabel?.font = UIFont.semiBold(size: 18)
        button.buttonConfig(button, cornerRadius: 20)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        setupShapeImageView()
        setupGoButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
}

// MARK: - UI design
extension FunnyMapTableViewCell {
    
    private func setupShapeImageView() {
        
        contentView.addSubview(shapeImageView)
        
        shapeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
       
            shapeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            shapeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            shapeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            shapeImageView.widthAnchor.constraint(equalToConstant: 100),
            shapeImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupGoButton() {
        
        contentView.addSubview(goButton)
        
        goButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
           
            goButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            goButton.centerYAnchor.constraint(equalTo: shapeImageView.centerYAnchor),
            goButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
