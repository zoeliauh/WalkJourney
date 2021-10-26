//
//  DetailRecordViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/26.
//

import UIKit

class DetailRecordViewController: UIViewController {
    
    lazy var headerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.Celadon
        view.clipsToBounds = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeader()
    }
    
    private func setupHeader() {
        
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        headerView.backgroundColor = UIColor.Celadon
    }
}
