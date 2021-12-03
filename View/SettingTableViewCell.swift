//
//  SettingTableViewCell.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/8.
//

import Foundation
import UIKit

class SettingTableViewCell: UITableViewCell {
    
    lazy var itemLabel: UILabel = {
        
        let label = UILabel()
        
        label.textColor = .black
        label.font = UIFont.regular(size: 20)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupItemLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not beed implemented")
    }
}

// MARK: - UI design
extension SettingTableViewCell {
    
    private func setupItemLabel() {
        
        contentView.addSubview(itemLabel)
        
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            itemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            itemLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            itemLabel.heightAnchor.constraint(equalToConstant: 40),
            itemLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}
