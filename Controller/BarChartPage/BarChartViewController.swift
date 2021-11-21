//
//  BarChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit

class BarChartViewController: UIViewController {
    
    private enum ChartType: Int {
        
        case dayChart = 0
                
        case monthChart = 1
    }
    
    private struct Segue {
        
        static let day = "SegueDay"
                
        static let month = "SegueMonth"
    }
    
    @IBOutlet weak var dayContainerView: UIView!
        
    @IBOutlet weak var monthContainerView: UIView!
    
    var containerViews: [UIView] {

        return [dayContainerView, monthContainerView]
    }
    
    lazy var chartSegmentedControl: UISegmentedControl = {
        
        let items = ["天", "月"]
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
        
        guard let type = ChartType(rawValue: segmentedControl.selectedSegmentIndex) else { return }

        updateContainer(type: type)
    }
        
    private func updateContainer(type: ChartType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .dayChart:
            dayContainerView.isHidden = false
            
        case .monthChart:
            monthContainerView.isHidden = false
            
        }
    }
    
    // MARK: - UI design
    private func setupChartSegmentedControl() {
        
        view.addSubview(chartSegmentedControl)
        
        chartSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            chartSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartSegmentedControl.widthAnchor.constraint(equalToConstant: 300),
            chartSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            chartSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
