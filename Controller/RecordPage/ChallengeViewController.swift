//
//  ChallengeViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/7.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    lazy var recordTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ChallengeTableViewCell.self, forCellReuseIdentifier: ChallengeTableViewCell.identifier)
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
    
    var screenshotURL: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecordStepsData()
        setupRecordTableView()
        refreshTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchRecordStepsData()
    }
    
    @objc func navDetailRecordVC(_ sender: UIButton) {
        
        guard let challengeShareVC = UIStoryboard.record.instantiateViewController(
            withIdentifier: String(describing: ChallengeShareViewController.self)
        ) as? ChallengeShareViewController else { return }
        
        challengeShareVC.screenshotURL = journeyRecords[sender.tag].screenshot
        
        navigationController?.pushViewController(challengeShareVC, animated: true)
    }
    
    func fetchRecordStepsData() {
        
        RecordManager.shared.fetchChallengeRecord { [weak self] result in
            switch result {
                
            case .success(let journeyRecords):
                
                self?.journeyRecords = journeyRecords
                
                self?.journeyRecords.sort { $0.createdTime ?? 0 > $1.createdTime ?? 0 }
                
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
}

extension ChallengeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return journeyRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChallengeTableViewCell.identifier,
            for: indexPath
        ) as? ChallengeTableViewCell else { fatalError("can not dequeue") }
        
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
        
        guard let challengeShareVC = UIStoryboard.record.instantiateViewController(
            withIdentifier: String(describing: ChallengeShareViewController.self)
        ) as? ChallengeShareViewController else { return }
        
        challengeShareVC.screenshotURL = journeyRecords[indexPath.row].screenshot
        
        self.navigationController?.pushViewController(challengeShareVC, animated: true)
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

// MARK: - UI design
extension ChallengeViewController {
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
