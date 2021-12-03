//
//  RecordViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/18.
//

import UIKit

class RecordViewController: UIViewController {
    
    lazy var recordTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RecordTableViewCell.self, forCellReuseIdentifier: RecordTableViewCell.identifier)
        tableView.reloadData()

        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl! = {

        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "更新中...")

        return refreshControl
    }()
                
    var journeyRecords: [StepData] = [] {
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    @objc func navDetailRecordVC(_ sender: UIButton) {

        guard let detailRecordVC = UIStoryboard.record.instantiateViewController(
            withIdentifier: String(describing: DetailRecordViewController.self)
        ) as? DetailRecordViewController else { return }
        
        detailRecordVC.latitudeArr = journeyRecords[sender.tag].latitude
        
        detailRecordVC.longitudeArr = journeyRecords[sender.tag].longitude
        
        detailRecordVC.walkDate = Date.dateFormatter.string(
            from: Date.init(milliseconds: journeyRecords[sender.tag].createdTime ?? Int64(0.0)))
        
        detailRecordVC.walkTime = journeyRecords[sender.tag].durationOfTime
        
        detailRecordVC.walkStep = journeyRecords[sender.tag].numberOfSteps
        
        detailRecordVC.walkDistance = journeyRecords[sender.tag].distanceOfWalk
        
        navigationController?.pushViewController(detailRecordVC, animated: true)
    }
    
    func fetchRecordStepsData() {
        
        RecordManager.shared.fetchWalkBySelfRecord { [weak self] result in
        
            switch result {
                
            case .success(let journeyRecords):
                
                self?.journeyRecords = journeyRecords
                                                
            case .failure(let error):
                
                print("fetchStepsData.failure: \(error)")
            }
        }
    }
    
    func deleteRecordStepsData(indexPath: IndexPath) {
        
        guard let createdTime = journeyRecords[indexPath.row].createdTime else { return }
        
        RecordManager.shared.deleteRecord(createdTime: createdTime)                
        journeyRecords.remove(at: indexPath.row)
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

extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return journeyRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RecordTableViewCell.identifier,
            for: indexPath
        ) as? RecordTableViewCell else { fatalError("can not dequeue") }
                
        cell.dateLabel.text = Date.dateFormatter.string(
            from: Date.init(
                milliseconds: journeyRecords[indexPath.row].createdTime ?? Int64(0.0)))
        
        cell.stepsLabel.text = "\(journeyRecords[indexPath.row].numberOfSteps.description) 步"
        
        cell.detailButton.tag = indexPath.item
        
        cell.selectionStyle = .none
        
        cell.detailButton.addTarget(self, action: #selector(navDetailRecordVC(_:)), for: .touchUpInside)
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailRecordVC = UIStoryboard.record.instantiateViewController(
            withIdentifier: String(describing: DetailRecordViewController.self)
        ) as? DetailRecordViewController else { return }
        
        detailRecordVC.latitudeArr = journeyRecords[indexPath.row].latitude
        
        detailRecordVC.longitudeArr = journeyRecords[indexPath.row].longitude
        
        detailRecordVC.walkDate = Date.dateFormatter.string(
            from: Date.init(milliseconds: journeyRecords[indexPath.row].createdTime ?? Int64(0.0)))
        
        detailRecordVC.walkTime = journeyRecords[indexPath.row].durationOfTime
        
        detailRecordVC.walkStep = journeyRecords[indexPath.row].numberOfSteps
        
        detailRecordVC.walkDistance = journeyRecords[indexPath.row].distanceOfWalk
        
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
