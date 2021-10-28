//
//  BarChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit

class BarChartViewController: UIViewController {
    
    lazy var chartSegmentedControl: UISegmentedControl = {
        
        let items = ["天", "週", "月"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.Celadon
        segmentedControl.selectedSegmentTintColor = UIColor.Sky
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 20) ], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChartSegmentedControl()
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            view.backgroundColor = .blue
        case 1:
            view.backgroundColor = .white
        case 2:
            view.backgroundColor = .purple
        default:
            break
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
