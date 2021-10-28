//
//  MonthChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Charts

class MonthChartViewController: UIViewController {
    
    lazy var totalLabel: UILabel = {
        
        let label = UILabel()
        label.text = "平均步數 (天)"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepsNumLabel: UILabel = {
        
        let label = UILabel()
        label.text = "965"
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
    
    lazy var monthChartView: BarChartView = {
        
        let monthChartView = BarChartView()
        return monthChartView
    }()
    
    var stepData: [StepData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTotalLabel()
        setupStepsNumLabel()
        setupStepLabel()
        setupMonthChartView()
        monthChartView.noDataText = "暫時沒有步行紀錄"
        fetchRecordStepsData()
        setupMonthChartDate(stepsData: stepData)
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
    
    func setupMonthChartView() {
        
        view.addSubview(monthChartView)
        
        monthChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            monthChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            monthChartView.topAnchor.constraint(equalTo: stepsNumLabel.bottomAnchor, constant: 50),
            monthChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            monthChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }
    
    func setupMonthChartDate(stepsData: [StepData]) {
        
        var stepsDataDict: [String: Int] = {
            
            var dict: [String: Int] = [:]
            
            for index in 1...30 {
                dict["\(index)"] = 0
            }
            
            return dict
        }()
        
        var dataEntries: [BarChartDataEntry] = []
        
        stepsData.forEach { steps in
            
            let stepsDate = Date.dateFormatter.string(from: Date.init(milliseconds: steps.createdTime ?? Int64(0.0)))
        
            let formatter = DateFormatter()

            formatter.dateFormat = "M月"
//            let month = formatter.string(from: stepsDate)
            
            let month = "12月"
            
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
        
        monthChartView.data = chartData
                
        var xValues: [String] = []
        
        for index in 0...30 {
            xValues.append("\(index)")
        }
        
        monthChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        monthChartView.xAxis.drawGridLinesEnabled = false
        monthChartView.xAxis.labelPosition = .bottom
        monthChartView.xAxis.granularity = 1
        monthChartView.xAxis.labelRotationAngle = -25
        monthChartView.xAxis.setLabelCount(12, force: false)
        
        monthChartView.leftAxis.drawGridLinesEnabled = false
        monthChartView.leftAxis.granularity = 1.0
        monthChartView.leftAxis.axisMinimum = 0.0
        
        monthChartView.legend.enabled = false
        monthChartView.extraBottomOffset = 20
        
        monthChartView.animate(xAxisDuration: 0, yAxisDuration: 2)
        
        monthChartView.rightAxis.enabled = false
    }
}
