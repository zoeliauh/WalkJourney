//
//  ChallengeShareViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/7.
//

import UIKit

class ChallengeShareViewController: UIViewController {
    
    lazy var popButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        return button
    }()
    
    lazy var moreButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up.fill"), for: .normal)
        return button
    }()
    
    lazy var screenshotImageView: UIImageView = {
        
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
        
        setupScreenshotImageView()
        setUpBackButton()
        setUpMoreButton()
    }
    
    @objc func popBack() {

        navigationController?.popViewController(animated: true)
    }
    
    @objc func popMore() {
        
        let controller = UIAlertController(title: "更多功能", message: "", preferredStyle: .actionSheet)
        let names = ["下載", "分享"]
        for name in names {
           let action = UIAlertAction(title: name, style: .default) { action in
               print(action.title ?? "no action")
           }
           controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension ChallengeShareViewController {
    // MARK: - UI design
    private func setUpBackButton() {
                
        view.addSubview(popButton)
        
        popButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            popButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            popButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            popButton.heightAnchor.constraint(equalToConstant: 40),
            popButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        popButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
    }
    
    private func setUpMoreButton() {
                
        view.addSubview(moreButton)
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            moreButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            moreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            moreButton.heightAnchor.constraint(equalToConstant: 40),
            moreButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        moreButton.addTarget(self, action: #selector(popMore), for: .touchUpInside)
    }

    private func setupScreenshotImageView() {
        
        view.addSubview(screenshotImageView)
        
        screenshotImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            screenshotImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenshotImageView.topAnchor.constraint(equalTo: view.topAnchor),
            screenshotImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screenshotImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
