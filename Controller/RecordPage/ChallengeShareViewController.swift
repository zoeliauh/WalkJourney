//
//  ChallengeShareViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/7.
//

import UIKit

class ChallengeShareViewController: UIViewController {
        
    var screenshotURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
                
        setupScreenshotImageView()
        setUpBackButton()
        setUpShareButton()
    }
    
    @objc func popBack() {

        navigationController?.popViewController(animated: true)
    }
    
    @objc func popMore() {
        
        present(.confirmationAlert(
            title: nil, message: nil,
            preferredStyle: .actionSheet,
            actions: [
                UIAlertAction.addAction(
                    title: "儲存至相簿", style: .default,
                    handler: { [weak self] _ in
                        
                        self?.popMoreHandle()
                    }
                ), UIAlertAction.addAction(
                    title: "分享至社群", style: .default,
                    handler: { [weak self] _ in
                        self?.createNewPost()
                        Toast.showSuccess(text: "已分享")
                        print("createNewPost")
                    }
                ), UIAlertAction.addAction(title: String.cancelMandarin, style: .cancel, handler: nil)
            ]
        ), animated: true, completion: nil)
    }
    
    private func createNewPost() {
        
        guard let screenshotURL = screenshotURL else { return }
        
        PublicPostManager.shared.createPublicPost(screenshotURL: screenshotURL) { result in
            
            switch result {
                
            case .success:
                
                print("success to create new location")
                
            case .failure(let error):
                
                print("create location.failure: \(error)")
            }
        }
    }
    
    lazy var popButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.backIcon), for: .normal)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.share), for: .normal)
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
    
    func popMoreHandle() {
        
        self.popButton.isHidden = true
        self.shareButton.isHidden = true
        let screenshotImage = self.view.takeScreenshot()
        UIImageWriteToSavedPhotosAlbum(screenshotImage, nil, nil, nil)
        Toast.showSuccess(text: "已下載")
        self.popButton.isHidden = false
        self.shareButton.isHidden = false
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
    
    private func setUpShareButton() {
                
        view.addSubview(shareButton)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            shareButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            shareButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        shareButton.addTarget(self, action: #selector(popMore), for: .touchUpInside)
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
