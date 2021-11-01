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
        label.text = "0"
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
    
    lazy var dayChartView: BarChartView = {
        
        let dayChartView = BarChartView()
        return dayChartView
    }()
    
    let dateFormat = DateFormatter()
    
    let dateFormatHour = DateFormatter()
    
    var selectedDay = Date()
    
    var stepDataArr: [StepData] = []
    
    var stepSum = 0 {
        didSet {
            stepsNumLabel.text = stepSum.description
            dayChartView.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTotalLabel()
        setupStepsNumLabel()
        setupStepLabel()
        setupcalendarDatePicker()
        setupDayChartView()
        dayChartView.noDataText = "暫時沒有步行紀錄"
        fetchRecordStepsData()
    }
    // MARK: - fetch record steps data
    func fetchRecordStepsData() {
        
        dateFormat.dateFormat = "yyyy.MM.dd"

        RecordAfterWalkingManager.shared.fetchDateRecord(calenderDay: dateFormat.string(from: selectedDay)) { [weak self] result in
            switch result {
                
            case .success(let stepData):
                
                self?.stepDataArr = stepData
                self?.setupDayChartDate(stepDataArr: stepData)

                for items in stepData {
                    
                    self?.stepSum += items.numberOfSteps
                }
                                
            case .failure(let error):
                
                print("fetchStepsData.failure: \(error)")
            }
        }
    }
    
    // MARK: - datePicker action
    @objc func dateChecked(_ sender: UIDatePicker) {
                                        
        dateFormat.dateFormat = "yyyy.MM.dd"

        selectedDay = calendarDatePicker.date
                
        self.stepSum = 0
        
        fetchRecordStepsData()
    
        setupDayChartDate(stepDataArr: stepDataArr)
    }
    // MARK: - setup Bar Chart
    private func setupDayChartDate(stepDataArr: [StepData]) {
        
        chartAsixSetup()
        
        dateFormatHour.dateFormat = "HH"
                
        var stepsDic: [String: Int] = {
            
            var dict: [String: Int] = [:]
            
            for index in 0...23 {
                dict["\(index)"] = 0
            }
            
            return dict
        }()
        
        var dataEntries = [BarChartDataEntry]()
        
        for items in stepDataArr {
            
            let walkHour = dateFormatHour.string(from: Date.init(milliseconds: items.createdTime ?? Int64(0.0)))
            
            print("\(items.date) walk \(items.numberOfSteps) at \(walkHour)" )
            
            stepsDic[walkHour, default: 0] += items.numberOfSteps
        }
        
        let values = Array(stepsDic)
        
        let hours = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
        
        for index in hours {
            
            guard let doubleIndex = Double(index) else { return }
            
            let dataEntry = BarChartDataEntry(x: Double(doubleIndex),
                                              y: Double(stepsDic["\(index)"] ?? 0))
            
            dataEntries.append(dataEntry)
        }
        
        let set = BarChartDataSet(entries: dataEntries, label: nil)
        
        set.colors = ChartColorTemplates.celadon()
        
        let data = BarChartData(dataSet: set)
        
        dayChartView.data = data
    }

    func chartAsixSetup() {
        
        var xValues: [String] = []
        
        for index in 0...23 {
            xValues.append("\(index)")
        }
        
        dayChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        dayChartView.xAxis.drawGridLinesEnabled = false
        dayChartView.xAxis.labelPosition = .bottom
        dayChartView.xAxis.granularity = 1
        dayChartView.xAxis.labelRotationAngle = 0
        
        dayChartView.leftAxis.drawGridLinesEnabled = false
        dayChartView.leftAxis.granularity = 1.0
        dayChartView.leftAxis.axisMinimum = 0.0
        
        dayChartView.legend.enabled = false
        dayChartView.extraBottomOffset = 20
        
        dayChartView.animate(xAxisDuration: 0, yAxisDuration: 1)
        
        dayChartView.rightAxis.enabled = false
    }
}

extension DayChartViewController {
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
    
    private func setupDayChartView() {
        
        view.addSubview(dayChartView)
        
        dayChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            dayChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dayChartView.topAnchor.constraint(equalTo: calendarDatePicker.bottomAnchor, constant: 50),
            dayChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dayChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }
}
