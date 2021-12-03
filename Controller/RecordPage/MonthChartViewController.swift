//
//  MonthChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Charts

class MonthChartViewController: UIViewController {
    
    var selectedYear: String = ""
        
    var selectedMonth: String = ""
            
    var journeyRecords: [StepData] = []
    
    var monthOfDays: Int = 30
    
    var stepSum = 0 {
        didSet {
            monthChartView.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackButton()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupMonthChartView()
        setupMonthChartDate(journeyRecords: journeyRecords)
        monthChartView.noDataText = "暫時沒有步行紀錄"
        setupDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupDateLabel()
    }
    
    @objc func popBack() {
        
        navigationController?.popViewController(animated: true)
    }
    
    private func setupMonthChartDate(journeyRecords: [StepData]) {
        
        let dateFormatDay = DateFormatter()
        
        if journeyRecords.count == 0 {
            
            monthChartView.noDataText = "暫時沒有步行紀錄"
        } else {
            
            chartAsixSetup()
            
            monthOfDays = TimeManager.shared.getDaysInMonth(
                month: Int(selectedMonth) ?? 0,
                year: Int(selectedYear) ?? 0
            ) ?? 30
            
            dateFormatDay.dateFormat = "dd"
            
            var stepsDic: [String: Int] = {
                
                var dict: [String: Int] = [:]
                
                for index in 1...monthOfDays {
                    dict["\(index)"] = 0
                }
                
                return dict
            }()
            
            var dataEntries: [BarChartDataEntry] = []
            
            for items in journeyRecords {
                
                let walkDay = dateFormatDay.string(from: Date.init(milliseconds: items.createdTime ?? Int64(0.0)))
                                
                stepsDic[walkDay, default: 0] += items.numberOfSteps
            }
            
            var xValues: [String] = []
            
            for index in 1...monthOfDays {
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
            
            chartDataSet.colors = ChartColorTemplates.liberty()
            
            let chartData = BarChartData(dataSet: chartDataSet)
            
            monthChartView.data = chartData
        }
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
    
    lazy var dateLabel: UILabel = {
        
        let label = UILabel()
        label.text = "\(selectedYear)年  \(selectedMonth)月"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var popButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage.asset(.backIcon), for: .normal)
        return button
    }()
    
    lazy var monthChartView: BarChartView = {
        
        let monthChartView = BarChartView()
        return monthChartView
    }()
    
}

extension MonthChartViewController {
    
    private func setupDateLabel() {
        
        view.addSubview(dateLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: popButton.topAnchor, constant: 30)
        ])
    }
    
    private func setUpBackButton() {
        
        view.addSubview(popButton)
        
        popButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            popButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            popButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            popButton.heightAnchor.constraint(equalToConstant: 40),
            popButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        popButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
    }
    
    private func setupMonthChartView() {
        
        view.addSubview(monthChartView)
        
        monthChartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            monthChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            monthChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            monthChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            monthChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])
    }
}
