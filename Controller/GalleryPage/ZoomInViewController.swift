//
//  ZoomInViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/19.
//

import UIKit

class ZoomInViewController: UIViewController {
    
    lazy var gpsImageView: UIImageView = {
        
        let url = screenshotURL
        let imageView = UIImageView()
        imageView.loadImage(screenshotURL, placeHolder: nil)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    var screenshotURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGpsImageView()
    }
    
    private func setupGpsImageView() {
        
        view.addSubview(gpsImageView)
        
        gpsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            gpsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gpsImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gpsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gpsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
