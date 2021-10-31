//
//  WeekChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Charts

class WeekChartViewController: UIViewController {
    
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
        label.text = "5968"
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
    
    lazy var calendarDatePicker: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "zh_Hant_TW")
    
        datePicker.addTarget(self, action: #selector(dateChecked(_:)), for: .valueChanged)
        return datePicker
    }()
    
    lazy var weekChartView: BarChartView = {
        
        let weekChartView = BarChartView()
        return weekChartView
    }()
    
    var stepDataArr: [StepData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTotalLabel()
        setupStepsNumLabel()
        setupStepLabel()
        setupcalendarDatePicker()
        setupWeekChartView()
        weekChartView.noDataText = "暫時沒有步行紀錄"
        fetchRecordStepsData()
    }
    
    // MARK: - fetch record steps data
    func fetchRecordStepsData() {

        RecordAfterWalkingManager.shared.fetchRecord { [weak self] result in
            switch result {

            case .success(let stepData):

                self?.stepDataArr = stepData
                self?.setupWeekChartDate(stepDataArr: stepData)
                
            case .failure(let error):

                print("fetchStepsData.failure: \(error)")
            }
        }
    }
        // MARK: - datePicker action
        @objc func dateChecked(_ sender: UIDatePicker) {
            
            setupWeekChartDate(stepDataArr: stepDataArr)
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy.MM.dd HH:mm"
            dateFormat.dateStyle = .long
            dateFormat.timeStyle = .none
            dateFormat.timeZone = TimeZone(secondsFromGMT: +8)
        }
    
    func setupWeekChartDate(stepDataArr: [StepData]) {
        
        var stepsDataDict: [String: Int] = {
            
            var dict: [String: Int] = [:]
            
            for index in 1...7 {
                dict["\(index)月"] = 0
            }
            
            return dict
        }()
        
        var dataEntries: [BarChartDataEntry] = []
        
        let values = Array(stepsDataDict)
        
        for index in 0..<values.count {
            
            let dataEntry = BarChartDataEntry(x: Double(index),
                                              y: Double(stepsDataDict["\(index + 1)月"] ?? 0))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        
        let chartData = BarChartData(dataSet: chartDataSet)
                
        weekChartView.data = chartData
        
        let xValues = ["日", "一", "二", "三", "四", "五", "六"]
        
        weekChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        weekChartView.xAxis.drawGridLinesEnabled = false
        weekChartView.xAxis.labelPosition = .bottom
        weekChartView.xAxis.granularity = 1
        weekChartView.xAxis.labelRotationAngle = -25
        weekChartView.xAxis.setLabelCount(12, force: false)
        
        weekChartView.leftAxis.drawGridLinesEnabled = false
        weekChartView.leftAxis.granularity = 1.0
        weekChartView.leftAxis.axisMinimum = 0.0
        
        weekChartView.legend.enabled = false
        weekChartView.extraBottomOffset = 20
        
        weekChartView.animate(xAxisDuration: 0, yAxisDuration: 2)
        
        weekChartView.rightAxis.enabled = false
    }
}

extension WeekChartViewController {
    // MARK: - UI design
    private func setupTotalLabel() {
        
        view.addSubview(totalLabel)
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            totalLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
    }
    
    private func setupStepsNumLabel() {
        
        view.addSubview(stepsNumLabel)
        
        stepsNumLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            stepsNumLabel.centerYAnchor.constraint(equalTo: totalLabel.centerYAnchor),
            stepsNumLabel.leadingAnchor.constraint(equalTo: totalLabel.trailingAnchor, constant: 10)
        ])
    }
    
    private func setupStepLabel() {
        
        view.addSubview(stepLabel)
        
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            stepLabel.centerYAnchor.constraint(equalTo: stepsNumLabel.centerYAnchor),
            stepLabel.leadingAnchor.constraint(equalTo: stepsNumLabel.trailingAnchor, constant: 10)
        ])
    }
    
    private func setupcalendarDatePicker() {
        
        view.addSubview(calendarDatePicker)
        
        calendarDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            calendarDatePicker.leadingAnchor.constraint(equalTo: totalLabel.leadingAnchor),
            calendarDatePicker.topAnchor.constraint(equalTo: stepsNumLabel.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupWeekChartView() {
        
        view.addSubview(weekChartView)
        
        weekChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            weekChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weekChartView.topAnchor.constraint(equalTo: calendarDatePicker.bottomAnchor, constant: 50),
            weekChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weekChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }
}
