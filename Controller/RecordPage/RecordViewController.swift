//
//  RecordViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit

class RecordViewController: UIViewController {
        
    lazy var headerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.Celadon
        view.clipsToBounds = true
        return view
    }()
    
    lazy var headerTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "歷史紀錄"
        label.textAlignment = .center
        return label
    }()
    
    lazy var recordTableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.bounces = false
        table.rowHeight = UITableView.automaticDimension
        table.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.identifier)
        return table
    }()
    
    var dateFormatter = DateFormatter()
    
    var stepData: [StepData] = []
    
    var creatTimeArr: [TimeInterval] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeader()
        setupHeaderTitleLabel()
        setupRecordTableView()
        
        fetchRecordStepsData()
    }
    
    @objc func navDetailRecordVC(_ sender: UIButton) {
        
        guard let detailRecordVC = UIStoryboard.record.instantiateViewController(withIdentifier: "DetailRecord") as? DetailRecordViewController else { return }
        
        navigationController?.pushViewController(detailRecordVC, animated: true)
    }
    
    func fetchRecordStepsData() {

        RecordAfterWalkingManager.shared.fetchRecord { [weak self] result in
            switch result {

            case .success(let stepData):

                self?.stepData = stepData
                self?.recordTableView.reloadData()
                
                print(stepData)

            case .failure(let error):

                print("fetchStepsData.failure: \(error)")
            }
        }
    }
    
    // MARK: - UI design
    private func setupHeader() {
        
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        headerView.backgroundColor = UIColor.Celadon
    }
    
    private func setupHeaderTitleLabel() {
        
        headerView.addSubview(headerTitleLabel)
        
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10)
        ])
    }
    
    func setupRecordTableView() {
        
        view.addSubview(recordTableView)
        
        recordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            recordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            recordTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recordTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        
//        let date = Date(timeIntervalSince1970: TimeInterval(creatTimeArr[indexPath.row]))
                        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as? RecordTableViewCell else { fatalError("can not dequeue") }
                
        cell.dateLabel.text = "dateFormatter.string(from: date)"
        
        cell.stepsLabel.text = "\(stepData[indexPath.row].numberOfSteps.description) 步"
        
        cell.detailButton.tag = indexPath.item
        
        cell.selectionStyle = .none
        
        cell.detailButton.addTarget(self, action: #selector(navDetailRecordVC(_:)), for: .touchUpInside)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailRecordVC = UIStoryboard.record.instantiateViewController(withIdentifier: "DetailRecord") as? DetailRecordViewController else { return }

        self.navigationController?.pushViewController(detailRecordVC, animated: true)
    }
}
