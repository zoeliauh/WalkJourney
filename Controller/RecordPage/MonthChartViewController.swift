//
//  MonthChartViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/27.
//

import UIKit
import Charts

class MonthChartViewController: UIViewController {
    
    lazy var popButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "backIcon"), for: .normal)
        return button
    }()
    
    lazy var monthChartView: BarChartView = {
        
        let monthChartView = BarChartView()
        return monthChartView
    }()
    
    var selectedYear: String = "2021"
        
    var selectedMonth: String = "11"
        
    let dateFormatDay = DateFormatter()
    
    var stepDataArr: [StepData] = []
    
    var numberOfDays: Int = 30
    
    var stepSum = 0 {
        didSet {
            monthChartView.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBackButton()
        setupMonthChartView()
        setupMonthChartDate(stepDataArr: stepDataArr)
        monthChartView.noDataText = "暫時沒有步行紀錄"
    }
    
    @objc func popBack() {
        
        navigationController?.popViewController(animated: true)
    }
    
    private func setupMonthChartDate(stepDataArr: [StepData]) {
        
        if stepDataArr.count == 0 {
            
            monthChartView.noDataText = "暫時沒有步行紀錄"
        } else {
            
            chartAsixSetup()
            
            numberOfDays = TimeManager.shared.getDaysInMonth(
                month: Int(selectedMonth) ?? 0,
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
}

extension MonthChartViewController {
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
