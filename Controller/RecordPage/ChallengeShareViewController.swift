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
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let names = ["儲存至相簿", "分享至社群"]
        
        if let popoverController = controller.popoverPresentationController {

                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(
                        x: self.view.bounds.midX, y: self.view.bounds.midY,
                        width: 0, height: 0
                    )
                    popoverController.permittedArrowDirections = []
                }
        
        for name in names {
           let action = UIAlertAction(title: name, style: .default) { _ in
               if name == "儲存至相簿" {
                   self.popButton.isHidden = true
                   self.shareButton.isHidden = true
                   let screenshotImage = self.view.takeScreenshot()
                   UIImageWriteToSavedPhotosAlbum(screenshotImage, nil, nil, nil)
                   Toast.showSuccess(text: "已下載")
                   self.popButton.isHidden = false
                   self.shareButton.isHidden = false
               } else {
                   self.createNewPost()
                   Toast.showSuccess(text: "已分享")
                   print("createNewPost")
               }
           }
           controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
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
