//
//  DayChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Charts

class DayChartViewController: UIViewController {
    
    lazy var totalLabel: UILabel = {
        
        let label = UILabel()
        label.text = "總步數"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepsNumLabel: UILabel = {
        
        let label = UILabel()
        label.text = "2968"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepLabel: UILabel = {
        
        let label = UILabel()
        label.text = "步"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var dayChartView: BarChartView = {
        
        let dayChartView = BarChartView()
        return dayChartView
    }()
    
    var stepData: [StepData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTotalLabel()
        setupStepsNumLabel()
        setupStepLabel()
        setupDayChartView()
        dayChartView.noDataText = "暫時沒有步行紀錄"
        fetchRecordStepsData()
        setupDayChartDate(stepsData: stepData)
    }
    // MARK: - fetch record steps data
    func fetchRecordStepsData() {

        RecordAfterWalkingManager.shared.fetchRecord { [weak self] result in
            switch result {

            case .success(let stepData):

                self?.stepData = stepData
                
            case .failure(let error):

                print("fetchStepsData.failure: \(error)")
            }
        }
    }
    
    // MARK: - UI design
    func setupTotalLabel() {
        
        view.addSubview(totalLabel)
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            totalLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupStepsNumLabel() {
        
        view.addSubview(stepsNumLabel)
        
        stepsNumLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            stepsNumLabel.centerXAnchor.constraint(equalTo: totalLabel.centerXAnchor),
            stepsNumLabel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 10),
//            stepsNumLabel.widthAnchor.constraint(equalToConstant: 100),
            stepsNumLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupStepLabel() {
        
        view.addSubview(stepLabel)
        
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            stepLabel.centerYAnchor.constraint(equalTo: stepsNumLabel.centerYAnchor),
            stepLabel.leadingAnchor.constraint(equalTo: stepsNumLabel.trailingAnchor, constant: 10)
        ])
    }
    
    func setupDayChartView() {
        
        view.addSubview(dayChartView)
        
        dayChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            dayChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            dayChartView.topAnchor.constraint(equalTo: stepsNumLabel.bottomAnchor, constant: 50),
            dayChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            dayChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }
    
    func setupDayChartDate(stepsData: [StepData]) {
        
        var stepsDataDict: [String: Int] = {
            
            var dict: [String: Int] = [:]
            
            for index in 1...24 {
                dict["\(index)月"] = 0
            }
            
            return dict
        }()
        
        var dataEntries: [BarChartDataEntry] = []
        
        stepsData.forEach { steps in
            
            let stepsDate = Date.dateFormatter.string(from: Date.init(milliseconds: steps.createdTime ?? Int64(0.0)))
        
            let formatter = DateFormatter()

            formatter.dateFormat = "M月"
//            let month = formatter.string(from: stepsDate)
            
            let month = "10月"
            
            stepsDataDict[month, default: 0] += 1
        }
        
        let values = Array(stepsDataDict)
        
        for index in 0..<values.count {
            
            let dataEntry = BarChartDataEntry(x: Double(index),
                                              y: Double(stepsDataDict["\(index + 1)月"] ?? 0))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartData.barWidth = Double(0.5)
        
        dayChartView.data = chartData
        
        var xValues: [String] = []
        
        for index in 0...23 {
            xValues.append("\(index)")
        }
        
        dayChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        dayChartView.xAxis.drawGridLinesEnabled = false
        dayChartView.xAxis.labelPosition = .bottom
        dayChartView.xAxis.granularity = 1
        dayChartView.xAxis.labelRotationAngle = 0
        dayChartView.xAxis.setLabelCount(12, force: false)
        
        dayChartView.leftAxis.drawGridLinesEnabled = false
        dayChartView.leftAxis.granularity = 1.0
        dayChartView.leftAxis.axisMinimum = 0.0
        
        dayChartView.legend.enabled = false
        dayChartView.extraBottomOffset = 20
        
        dayChartView.animate(xAxisDuration: 0, yAxisDuration: 2)
        
        dayChartView.rightAxis.enabled = false
    }
}
