//
//  DetailRecordViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/26.
//

import UIKit
import GoogleMaps

class DetailRecordViewController: UIViewController {
    
    lazy var logoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage.asset(.loginIcon)
        imageView.layer.cornerRadius = 30
        imageView.transform.rotated(by: 130)
        return imageView
    }()
    
    lazy var popButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.backIcon), for: .normal)
        return button
    }()
    
    lazy var moreButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.moreIcon), for: .normal)
        return button
    }()

    lazy var coverImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.layer.backgroundColor = UIColor.systemGray5.cgColor
        return imageView
    }()
    
    lazy var walkTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.semiBold(size: 20)
        label.text = walkTime
        label.textAlignment = .left
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var walkStepLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.semiBold(size: 20)
        label.text = "走了 \(walkStep ?? 0) 步"
        label.textAlignment = .left
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var walkDistanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.semiBold(size: 20)
        label.text = walkDistance
        label.textAlignment = .left
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var trackingMapView: GMSMapView = {
        
        let GMSMapView = GMSMapView()
        GMSMapView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        GMSMapView.layoutIfNeeded()
        return GMSMapView
    }()
        
    let locationManager = CLLocationManager()
        
    var latitudeArr: [CLLocationDegrees] = []
    
    var longitudeArr: [CLLocationDegrees] = []
    
    var indexPath: IndexPath?
    
    var path = GMSMutablePath()
        
    var walkDate: String?
    
    var walkTime: String?
    
    var walkStep: Int?
    
    var walkDistance: String?
    
    var tabbarHeight: CGFloat? = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: true)

        locationManager(locationManager, latitude: latitudeArr, longitude: longitudeArr)
    }

    override func viewDidLayoutSubviews() {
        tabbarHeight = self.tabBarController?.tabBar.frame.height
        setuptrackingMapView()
        setupCoverImageView()
        setupLogoImageView()
        setupWalkDistanceLabel()
        setupWalkStepLabel()
        setupWalkTimeLabel()
        setUpBackButton()
        setUpMoreButton()
    }
    
    @objc func popBack() {

        navigationController?.popViewController(animated: true)
    }
    
    @objc func popMore() {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let downloadAction = UIAlertAction(title: "儲存至相簿", style: .default) { _ in
            self.popButton.isHidden = true
            self.moreButton.isHidden = true
            let screenshotImage = self.view.takeScreenshot()
            UIImageWriteToSavedPhotosAlbum(screenshotImage, nil, nil, nil)
            Toast.showSuccess(text: "已下載")
            self.popButton.isHidden = false
            self.moreButton.isHidden = false
        }
        
        if let popoverController = controller.popoverPresentationController {

                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(
                        x: self.view.bounds.midX, y: self.view.bounds.midY,
                        width: 0, height: 0
                    )
                    popoverController.permittedArrowDirections = []
                }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(downloadAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension DetailRecordViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, latitude: [CLLocationDegrees], longitude: [CLLocationDegrees]) {
        
        trackingMapView.camera = GMSCameraPosition.camera(withLatitude: latitude[0], longitude: longitude[0], zoom: 16)
                        
        for index in 0..<latitude.count {
            
            path.addLatitude(latitudeArr[index], longitude: longitudeArr[index])
        
        let polyline = GMSPolyline(path: path)

                polyline.strokeWidth = 2

            polyline.strokeColor = UIColor.black

                polyline.geodesic = true

                polyline.map = self.trackingMapView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        manager.stopUpdatingLocation()
        
        print("Error: \(error)")
    }
}

extension DetailRecordViewController {
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
    
    private func setupCoverImageView() {
        
        view.addSubview(coverImageView)
        
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            coverImageView.bottomAnchor.constraint(equalTo: trackingMapView.bottomAnchor, constant: -75),
            coverImageView.heightAnchor.constraint(equalToConstant: 120),
            coverImageView.widthAnchor.constraint(equalToConstant: 150)
        
        ])
    }
    
    private func setupLogoImageView() {
        
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 90),
            logoImageView.bottomAnchor.constraint(equalTo: trackingMapView.bottomAnchor, constant: -80),
            logoImageView.heightAnchor.constraint(equalToConstant: 70),
            logoImageView.widthAnchor.constraint(equalToConstant: 70)
        
        ])
        
    }
    
    private func setupWalkTimeLabel() {
        
        view.addSubview(walkTimeLabel)
        
        walkTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            walkTimeLabel.leadingAnchor.constraint(equalTo: walkDistanceLabel.leadingAnchor),
            walkTimeLabel.bottomAnchor.constraint(equalTo: walkStepLabel.bottomAnchor, constant: -30),
            walkTimeLabel.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupWalkStepLabel() {
        
        view.addSubview(walkStepLabel)
        
        walkStepLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            walkStepLabel.leadingAnchor.constraint(equalTo: walkDistanceLabel.leadingAnchor),
            walkStepLabel.bottomAnchor.constraint(equalTo: walkDistanceLabel.bottomAnchor, constant: -30),
            walkStepLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupWalkDistanceLabel() {
        
        view.addSubview(walkDistanceLabel)
        
        walkDistanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            walkDistanceLabel.leadingAnchor.constraint(equalTo: trackingMapView.leadingAnchor, constant: 30),
            walkDistanceLabel.bottomAnchor.constraint(equalTo: trackingMapView.bottomAnchor, constant: -100),
            walkDistanceLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setuptrackingMapView() {
        
        view.addSubview(trackingMapView)
        
        trackingMapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            trackingMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackingMapView.topAnchor.constraint(equalTo: view.topAnchor),
            trackingMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackingMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
