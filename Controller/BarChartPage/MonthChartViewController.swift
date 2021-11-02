//
//  MonthChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Charts

class MonthChartViewController: UIViewController {
    
    lazy var averageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "平均步數 (天)"
        label.font = UIFont.kleeOneRegular(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepsNumLabel: UILabel = {
        
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.kleeOneRegular(ofSize: 40)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepLabel: UILabel = {
        
        let label = UILabel()
        label.text = "步"
        label.font = UIFont.kleeOneRegular(ofSize: 20)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    lazy var monthPickerTextField: PickerTestField = {
        
        let pickerTextField = PickerTestField()
        pickerTextField.backgroundColor = .lightGray
        pickerTextField.layer.cornerRadius = 10
        pickerTextField.textAlignment = .left
        pickerTextField.font = UIFont.systemFont(ofSize: 25)
        pickerTextField.pickerYear = ["2019年", "2020年", "2021年", "2022年", "2023年"]
        pickerTextField.pickerMonth = ["1月", "2月", "3月", "4月",
                                       "5月", "6月", "7月", "8月",
                                       "9月", "10月", "11月", "12月"]
        
        pickerTextField.displayNameHandle = { item in
            self.selectedYear = item[0..<4]
            self.yearMonth = item.components(separatedBy: " ")
            if self.yearMonth.count == 2 {
                self.selectedMonth = String(self.yearMonth[1].dropLast())
            }
            
            self.fetchRecordStepsData()
            return item
        }
        
        pickerTextField.text = "\(selectedYear)年 \(selectedMonth)月"
        
        return pickerTextField
    }()
    
    lazy var monthChartView: BarChartView = {
        
        let monthChartView = BarChartView()
        return monthChartView
    }()
    
    var selectedYear: String = "2021"
    
    var yearMonth: [String] = []
    
    var selectedMonth: String = "11"
    
    let comp = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
    
    let dateFormatDay = DateFormatter()
    
    var stepDataArr: [StepData] = []
    
    var numberOfDays: Int = 30
    
    var stepSum = 0 {
        didSet {
            stepsNumLabel.text = (stepSum / numberOfDays).description
            monthChartView.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAverageLabel()
        setupStepsNumLabel()
        setupStepLabel()
        setupMonthTestField()
        setupMonthChartView()
        monthChartView.noDataText = "暫時沒有步行紀錄"
        fetchRecordStepsData()
    }
    
    // MARK: - fetch record steps data
    func fetchRecordStepsData() {
        
        stepSum = 0
        
        RecordManager.shared.fetchMonthRecord(
            calenderDay: selectedYear + "." + selectedMonth
        ) { [weak self] result in
            
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
    
    private func setupMonthChartDate(stepDataArr: [StepData]) {
        
        chartAsixSetup()
        
        numberOfDays = getDaysInMonth(month: Int(selectedMonth) ?? 0,
                                      year: Int(selectedYear) ?? 0
        ) ?? 30
        
        dateFormatDay.dateFormat = "dd"
        
        var stepsDic: [String: Int] = {
            
            var dict: [String: Int] = [:]
            
            for index in 1...numberOfDays {
                dict["\(index)"] = 0
            }
            
            return dict
        }()
        
        var dataEntries: [BarChartDataEntry] = []
        
        for items in stepDataArr {
            
            let walkDay = dateFormatDay.string(from: Date.init(milliseconds: items.createdTime ?? Int64(0.0)))
            
            //            print("\(items.date) walk \(items.numberOfSteps) at \(walkDay)" )
            
            stepsDic[walkDay, default: 0] += items.numberOfSteps
        }
        
        var xValues: [String] = []
        
        for index in 1...numberOfDays {
            xValues.append(String(format: "%02d", index))
        }
        
        let days = xValues
        
        for index in days {
            
            guard let doubleIndex = Double(index) else { return }
            
            let dataEntry = BarChartDataEntry(x: Double(doubleIndex),
                                              y: Double(stepsDic["\(index)"] ?? 0))
            
            dataEntries.append(dataEntry)
        }
            
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        
        chartDataSet.colors = ChartColorTemplates.celadon()
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        monthChartView.data = chartData
    }
    
    func chartAsixSetup() {
        
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
    // MARK: - get days in month
    func getDaysInMonth(month: Int, year: Int) -> Int? {
        let calendar = Calendar.current
        
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        
        var endComps = DateComponents()
        endComps.day = 1
        endComps.month = month == 12 ? 1 : month + 1
        endComps.year = month == 12 ? year + 1 : year
        
        guard let startDate = calendar.date(from: startComps) else { return 1 }
        guard let endDate = calendar.date(from: endComps) else { return 28 }
        
        let diff = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        
        return diff.day
    }
}

extension MonthChartViewController {
    // MARK: - UI design
    private func setupMonthTestField() {
        
        view.addSubview(monthPickerTextField)
        
        monthPickerTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            monthPickerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            monthPickerTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            monthPickerTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupAverageLabel() {
        
        view.addSubview(averageLabel)
        
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            averageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            averageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
        ])
    }
    
    private func setupStepsNumLabel() {
        
        view.addSubview(stepsNumLabel)
        
        stepsNumLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stepsNumLabel.centerYAnchor.constraint(equalTo: averageLabel.centerYAnchor),
            stepsNumLabel.leadingAnchor.constraint(equalTo: averageLabel.trailingAnchor, constant: 10)
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
    
    private func setupMonthChartView() {
        
        view.addSubview(monthChartView)
        
        monthChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            monthChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            monthChartView.topAnchor.constraint(equalTo: averageLabel.bottomAnchor, constant: 50),
            monthChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            monthChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
    }
}
