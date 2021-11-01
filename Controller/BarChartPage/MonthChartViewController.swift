//
//  MonthChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Charts

class MonthChartViewController: UIViewController {
    
    lazy var monthLabel: UILabel = {
        
        let label = UILabel()
        label.text = "10 月"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
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
    
    lazy var monthChartView: BarChartView = {
        
        let monthChartView = BarChartView()
        return monthChartView
    }()
    
    let dateFormat = DateFormatter()
    
    let dateFormatDay = DateFormatter()
    
    var selectedMonth: Int = 1 {
        
        didSet {
            monthLabel.text = "\(selectedMonth.description) 月"
            monthChartView.reloadInputViews()
        }
    }
    
    var selectedDay = Date()
    
    var stepDataArr: [StepData] = []
    
    var stepSum = 0 {
        didSet {
            stepsNumLabel.text = (stepSum / 30).description
            monthChartView.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMonthLabel()
        setupTotalLabel()
        setupStepsNumLabel()
        setupStepLabel()
        setupcalendarDatePicker()
        setupMonthChartView()
        monthChartView.noDataText = "暫時沒有步行紀錄"
        fetchRecordStepsData()
    }
    
    // MARK: - fetch record steps data
    func fetchRecordStepsData() {
        
        dateFormat.dateFormat = "yyyy.MM"
        
        RecordAfterWalkingManager.shared.fetchMonthRecord(calenderDay: dateFormat.string(from: selectedDay)) { [weak self] result in
            switch result {
                
            case .success(let stepData):

                self?.stepDataArr = stepData
                self?.setupMonthChartDate(stepDataArr: stepData)
              
                for items in stepData {
                    
                    self?.stepSum += items.numberOfSteps
                }
                
            case .failure(let error):

                print("fetchStepsData.failure: \(error)")
            }
        }
    }
    
    @objc func dateChecked(_ sender: UIDatePicker) {
                                        
        dateFormat.dateFormat = "yyyy.MM"
        
        selectedDay = calendarDatePicker.date
        
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: selectedDay)
        
        guard let monthComp = dateComponents.month else { return }
        
        selectedMonth = monthComp
                
        self.stepSum = 0
        
        fetchRecordStepsData()
        
        setupMonthChartDate(stepDataArr: stepDataArr)
    }
    
    private func setupMonthChartDate(stepDataArr: [StepData]) {
        
        chartAsixSetup()
        
        dateFormatDay.dateFormat = "dd"
        
        var stepsDic: [String: Int] = {
            
            var dict: [String: Int] = [:]
            
            for index in 0...31 {
                dict["\(index)"] = 0
            }
            
            return dict
        }()
        
        var dataEntries: [BarChartDataEntry] = []
        
        for items in stepDataArr {
            
            let walkDay = dateFormatDay.string(from: Date.init(milliseconds: items.createdTime ?? Int64(0.0)))
            
            print("\(items.date) walk \(items.numberOfSteps) at \(walkDay)" )
            
            stepsDic[walkDay, default: 0] += items.numberOfSteps
        }
        
        let values = Array(stepsDic)

        for index in 1...31 {
            
            let dataEntry = BarChartDataEntry(x: Double(index),
                                              y: Double(stepsDic["\(index)"] ?? 0))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        
        chartDataSet.colors = ChartColorTemplates.celadon()
        
        let chartData = BarChartData(dataSet: chartDataSet)
                
        monthChartView.data = chartData
    }
            
    func chartAsixSetup() {
        
        var xValues: [String] = []
        
        for index in 1...31 {
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

extension MonthChartViewController {
    // MARK: - UI design
    private func setupMonthLabel() {
        
        view.addSubview(monthLabel)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            monthLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        ])
    }
    
    private func setupTotalLabel() {
        
        view.addSubview(totalLabel)
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            totalLabel.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: 10),
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
        
            calendarDatePicker.leadingAnchor.constraint(equalTo: monthLabel.leadingAnchor),
            calendarDatePicker.topAnchor.constraint(equalTo: stepsNumLabel.bottomAnchor, constant: 20)
        ])
    }

    private func setupMonthChartView() {
        
        view.addSubview(monthChartView)
        
        monthChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            monthChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            monthChartView.topAnchor.constraint(equalTo: calendarDatePicker.bottomAnchor, constant: 50),
            monthChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            monthChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }
}
