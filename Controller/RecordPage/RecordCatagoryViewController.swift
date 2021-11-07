//
//  RecordCatagoryViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/7.
//

import UIKit

class RecordCatagoryViewController: UIViewController {
    
    private enum RecordType: Int {
        
        case record = 0
        
        case challenge = 1
    }
    
    private struct Segue {
        
        static let day = "SegueRecord"
        
        static let month = "SegueChallenge"
    }
    
    @IBOutlet weak var recordContainerView: UIView!
    
    @IBOutlet weak var challengeContainerView: UIView!
    
    var containerViews: [UIView] {
        
        return [recordContainerView, challengeContainerView]
    }
    
    lazy var recordSegmentedControl: UISegmentedControl = {
        
        let items = ["歷史紀錄", "趣味地圖"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.C1
        segmentedControl.selectedSegmentTintColor = UIColor.C4
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.layer.shadowOpacity = 0.3
        segmentedControl.layer.shadowRadius = 2.0
        segmentedControl.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        segmentedControl.layer.shadowColor = UIColor.black.cgColor
        segmentedControl.setTitleTextAttributes([.font: UIFont.kleeOneRegular(ofSize: 20) ], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartSegmentedControl()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        
        guard let type = RecordType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        
        updateContainer(type: type)
    }
    
    private func updateContainer(type: RecordType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .record:
            recordContainerView.isHidden = false
            
        case .challenge:
            challengeContainerView.isHidden = false
            
        }
    }
    
    // MARK: - UI design
    private func setupChartSegmentedControl() {
        
        view.addSubview(recordSegmentedControl)
        
        recordSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            recordSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            recordSegmentedControl.widthAnchor.constraint(equalToConstant: 300),
            recordSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            recordSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
