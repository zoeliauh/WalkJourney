//
//  RecordViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit

class RecordViewController: UIViewController {
    
    lazy var recordTableView: UITableView = {
        
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.identifier)
        table.reloadData()

        return table
    }()
    
    lazy var refreshControl: UIRefreshControl! = {

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新中...")

        return refreshControl
    }()
                
    var stepData: [StepData] = [] {
        
        didSet {
            recordTableView.reloadData()
        }
    }
    
    var stepDataWithOutURL: [StepData] = []
    
    var screenshotURL: [String] = []
                    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecordStepsData()
        setupRecordTableView()
        refreshTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.isHidden = false
        fetchRecordStepsData()
    }
//    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    @objc func navDetailRecordVC(_ sender: UIButton) {

        guard let detailRecordVC = UIStoryboard.record.instantiateViewController(
            withIdentifier: "DetailRecord"
        ) as? DetailRecordViewController else { return }
        
        detailRecordVC.latitudeArr = stepData[sender.tag].latitude
        
        detailRecordVC.longitudeArr = stepData[sender.tag].longitude
        
        detailRecordVC.walkDate = Date.dateFormatter.string(
            from: Date.init(milliseconds: stepData[sender.tag].createdTime ?? Int64(0.0)
                           ))
        
        detailRecordVC.walkTime = stepData[sender.tag].durationOfTime
        
        detailRecordVC.walkStep = stepData[sender.tag].numberOfSteps
        
        detailRecordVC.walkDistance = stepData[sender.tag].distanceOfWalk
        
        navigationController?.pushViewController(detailRecordVC, animated: true)
    }
    
    func fetchRecordStepsData() {
        
        RecordManager.shared.fetchWalkBySelfRecord { [weak self] result in
        
            switch result {
                
            case .success(let stepData):
                
                self?.stepData = stepData
                                
            case .failure(let error):
                
                print("fetchStepsData.failure: \(error)")
            }
        }
    }
    
    func deleteRecordStepsData(indexPath: IndexPath) {
        
        guard let createdTime = stepData[indexPath.row].createdTime else { return }
        
        RecordManager.shared.deleteRecord(createdTime: createdTime)                
        stepData.remove(at: indexPath.row)
        recordTableView.deleteRows(at: [indexPath], with: .fade)
    }
        
        func refreshTableView() {
            
            recordTableView.addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            recordTableView.refreshControl = refreshControl
        }
        
        @objc func refresh() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                self?.recordTableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    
    // MARK: - UI design
    func setupRecordTableView() {
        
        view.addSubview(recordTableView)
        
        recordTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            recordTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recordTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
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
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecordTableViewCell.identifier,
            for: indexPath
        ) as? RecordTableViewCell else { fatalError("can not dequeue") }
                
        cell.dateLabel.text = Date.dateFormatter.string(
            from: Date.init(
                milliseconds: stepData[indexPath.row].createdTime ?? Int64(0.0)))
        
        cell.stepsLabel.text = "\(stepData[indexPath.row].numberOfSteps.description) 步"
        
        cell.detailButton.tag = indexPath.item
        
        cell.selectionStyle = .none
        
        cell.detailButton.addTarget(self, action: #selector(navDetailRecordVC(_:)), for: .touchUpInside)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailRecordVC = UIStoryboard.record.instantiateViewController(
            withIdentifier: "DetailRecord"
        ) as? DetailRecordViewController else { return }
        
        detailRecordVC.latitudeArr = stepData[indexPath.row].latitude
        
        detailRecordVC.longitudeArr = stepData[indexPath.row].longitude
        
        detailRecordVC.walkDate = Date.dateFormatter.string(
            from: Date.init(milliseconds: stepData[indexPath.row].createdTime ?? Int64(0.0)
                           ))
        
        detailRecordVC.walkTime = stepData[indexPath.row].durationOfTime
        
        detailRecordVC.walkStep = stepData[indexPath.row].numberOfSteps
        
        detailRecordVC.walkDistance = stepData[indexPath.row].distanceOfWalk
        
        self.navigationController?.pushViewController(detailRecordVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            tableView.beginUpdates()
                        
            deleteRecordStepsData(indexPath: indexPath)
                                    
            tableView.endUpdates()
        }
    }
}
