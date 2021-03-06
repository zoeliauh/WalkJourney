//
//  RecordCatagoryViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/7.
//

import UIKit
import Lottie

class RecordCatagoryViewController: UIViewController {
    
    private enum RecordType: Int {
        
        case record = 0
        
        case challenge = 1
    }
    
    private struct Segue {
        
        static let day = "SegueRecord"
        
        static let month = "SegueChallenge"
    }
    
    @IBOutlet weak var recordContainerView: UIView!
    
    @IBOutlet weak var challengeContainerView: UIView!
    
    var containerViews: [UIView] {
        
        return [recordContainerView, challengeContainerView]
    }
        
    var selectedYear: String = Date.yearFormat()
    
    var yearMonth: [String] = []
    
    var selectedMonth: String = Date.monthFormat()
    
    var currentDate: String = "" {
        
        didSet {
            currentDate = "\(selectedYear) + . + \(selectedMonth)"
        }
    }
        
    var journeyRecords: [StepData] = []
    
    var monthOfDays: Int = 30
    
    var totalStep = 0 {
        
        didSet {
            stepsNumLabel.text = (totalStep / monthOfDays).description
        }
    }
    
    lazy var monthPickerTextField: PickerTestField = {
        
        let pickerTextField = PickerTestField()
        pickerTextField.tintColor = .clear
        pickerTextField.layer.cornerRadius = 10
        pickerTextField.textAlignment = .left
        pickerTextField.font = UIFont.boldSystemFont(ofSize: 30)
        pickerTextField.pickerYear = ["2019年", "2020年", "2021年", "2022年", "2023年", "2024年", "2025年"]
        pickerTextField.pickerMonth = ["01月", "02月", "03月", "04月",
                                       "05月", "06月", "07月", "08月",
                                       "09月", "10月", "11月", "12月"]
        
        pickerTextField.displayNameHandle = { item in
            self.selectedYear = item[0..<4]
            self.yearMonth = item.components(separatedBy: " ")
            if self.yearMonth.count == 2 {
                self.selectedMonth = String(self.yearMonth[1].dropLast())
            }
            
            self.fetchRecordStepsData()
            return item
        }
        
        pickerTextField.text = "\(selectedYear)年  \(selectedMonth)月"
        
        return pickerTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
        
        self.navigationController?.navigationBar.isHidden = true
        
        fetchRecordStepsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMonthTextField()
        setupPullImageView()
        setupBackgroundView()
        setupAverageLabel()
        setupStepsNumLabel()
        setupStepLabel()
        setupPushButton()
        setupChartSegmentedControl()
    }
    
    @objc func pushToMonthChartVC(_ sender: UIButton!) {
        
        guard let monthChartViewController = UIStoryboard.record.instantiateViewController(
            withIdentifier: String(describing: MonthChartViewController.self)
        ) as? MonthChartViewController else { return }
        
        monthChartViewController.selectedYear = selectedYear
        
        monthChartViewController.selectedMonth = selectedMonth
        
        monthChartViewController.journeyRecords = journeyRecords
        
        self.navigationController?.pushViewController(monthChartViewController, animated: true)
    }
    
    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
        
        guard let type = RecordType(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        
        updateContainer(type: type)
    }
    
    private func updateContainer(type: RecordType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .record:
            recordContainerView.isHidden = false
            
        case .challenge:
            challengeContainerView.isHidden = false
        }
    }
    
    func fetchRecordStepsData() {
        
        setupLottie()
        
        var totalStep = 0
        
        var steps: [Int] = []
        
        let group = DispatchGroup()
        
        RecordManager.shared.fetchMonthRecord(
            calenderDay: selectedYear + "." + selectedMonth
            
        ) { [weak self] result in
            
            group.enter()
            
            switch result {
                
            case .success(let stepData):
                
                self?.journeyRecords = stepData
                                
                for items in stepData {

                    steps.append(items.numberOfSteps)
                }

                totalStep = steps.reduce(0, { (totalStep, num) -> Int in

                    return totalStep + num
                })

                group.leave()
                
            case .failure(let error):
                
                print("fetchStepsData.failure: \(error)")
                
                group.leave()
            }
            
            group.notify(queue: .main) {
                
                self?.totalStep = totalStep 
                self?.animationView.removeFromSuperview()
            }
        }
        
        monthOfDays = TimeManager.shared.getDaysInMonth(month: Int(selectedMonth) ?? 0,
                                                         year: Int(selectedYear) ?? 0
        ) ?? 30
    }
    
    lazy var pullImageView: UIImageView = {
        
        var imageView = UIImageView()
        imageView.image = UIImage.asset(.pullIcon)
        
        return imageView
    }()
    
    lazy var backgroundView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = .C4
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layoutIfNeeded()
        
        return view
    }()
    
    lazy var averageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "平均"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepsNumLabel: UILabel = {
        
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var stepLabel: UILabel = {
        
        let label = UILabel()
        label.text = "步"
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var pushButton: UIButton = {
        
        var button = UIButton()
        button.setImage(UIImage.asset(.pushIcon), for: .normal)
        button.addTarget(self, action: #selector(pushToMonthChartVC(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var recordSegmentedControl: UISegmentedControl = {
        
        let items = [String.freeWalk, String.challengeMap]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = UIColor.systemGray6
        segmentedControl.selectedSegmentTintColor = UIColor.white
        segmentedControl.layer.cornerRadius = 10
        segmentedControl.clipsToBounds = true
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.shadowOpacity = 0.3
        segmentedControl.layer.shadowRadius = 2.0
        segmentedControl.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        segmentedControl.layer.shadowColor = UIColor.black.cgColor
        segmentedControl.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14) ], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    lazy var animationView: AnimationView = {
        
        var animationView = AnimationView()
        animationView = .init(name: String.loading)
        animationView.animationSpeed = 1
        animationView.layoutIfNeeded()
        return animationView
    }()
}

// MARK: - UI design
extension RecordCatagoryViewController {
    
    private func setupMonthTextField() {
        
        guard let nav = navigationController?.navigationBar else { return }
        
        nav.addSubview(monthPickerTextField)
        
        monthPickerTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            monthPickerTextField.leadingAnchor.constraint(equalTo: (nav.leadingAnchor), constant: 30),
            monthPickerTextField.topAnchor.constraint(equalTo: nav.topAnchor, constant: 15),
            monthPickerTextField.heightAnchor.constraint(equalToConstant: 30),
            monthPickerTextField.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupPullImageView() {
        
        monthPickerTextField.addSubview(pullImageView)
        
        pullImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            pullImageView.leadingAnchor.constraint(equalTo: (monthPickerTextField.trailingAnchor), constant: -60),
            pullImageView.topAnchor.constraint(equalTo: monthPickerTextField.topAnchor),
            pullImageView.heightAnchor.constraint(equalToConstant: 30),
            pullImageView.widthAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    private func setupBackgroundView() {
        
        view.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            backgroundView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupAverageLabel() {
        
        backgroundView.addSubview(averageLabel)
        
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            averageLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 30),
            averageLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -15)
        ])
    }
    
    private func setupStepsNumLabel() {
        
        backgroundView.addSubview(stepsNumLabel)
        
        stepsNumLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stepsNumLabel.leadingAnchor.constraint(equalTo: averageLabel.trailingAnchor, constant: 10),
            stepsNumLabel.lastBaselineAnchor.constraint(equalTo: averageLabel.lastBaselineAnchor)
        ])
    }
    
    private func setupStepLabel() {
        
        backgroundView.addSubview(stepLabel)
        
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stepLabel.leadingAnchor.constraint(equalTo: stepsNumLabel.trailingAnchor, constant: 10),
            stepLabel.lastBaselineAnchor.constraint(equalTo: averageLabel.lastBaselineAnchor)
        ])
    }
    
    private func setupPushButton() {
        
        backgroundView.addSubview(pushButton)
        
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            pushButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -15),
            pushButton.bottomAnchor.constraint(equalTo: averageLabel.bottomAnchor),
            pushButton.heightAnchor.constraint(equalToConstant: 30),
            pushButton.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupChartSegmentedControl() {
        
        view.addSubview(recordSegmentedControl)
        
        recordSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            recordSegmentedControl.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 30),
            recordSegmentedControl.widthAnchor.constraint(equalToConstant: 300),
            recordSegmentedControl.heightAnchor.constraint(equalToConstant: 30),
            recordSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupLottie() {
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        animationView.play()
    }
}
