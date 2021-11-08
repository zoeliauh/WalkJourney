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
        
        case weekChart = 1
        
        case monthChart = 2
    }
    
    private struct Segue {
        
        static let day = "SegueDay"
        
        static let week = "SegueWeek"
        
        static let month = "SegueMonth"
    }
    
    @IBOutlet weak var dayContainerView: UIView!
    
    @IBOutlet weak var weekContainerView: UIView!
    
    @IBOutlet weak var monthContainerView: UIView!
    
    var containerViews: [UIView] {

        return [dayContainerView, weekContainerView, monthContainerView]
    }
    
    lazy var chartSegmentedControl: UISegmentedControl = {
        
        let items = ["天", "週", "月"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.Celadon
        segmentedControl.selectedSegmentTintColor = UIColor.Sky
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.setTitleTextAttributes([.font: UIFont.kleeOneRegular(ofSize: 20) ], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartSegmentedControl()
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
            
        case .weekChart:
            weekContainerView.isHidden = false
            
        case .monthChart:
            monthContainerView.isHidden = false
            
        }
    }
    
    // MARK: - UI design
    private func setupChartSegmentedControl() {
        
        view.addSubview(chartSegmentedControl)
        
        chartSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            chartSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            chartSegmentedControl.widthAnchor.constraint(equalToConstant: 300),
            chartSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            chartSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
