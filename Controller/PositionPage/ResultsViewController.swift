//
//  ResultsViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/20.
//

import UIKit
import GoogleMaps
import CoreLocation

protocol ResultsViewControllerDelegate: AnyObject {
    func didTapPlace(with coordinate: CLLocationCoordinate2D, marker: GMSMarker)
}

class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsViewControllerDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var places: [Place] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        view.backgroundColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    public func update(with places: [Place]) {
        
        self.tableView.isHidden = false
        
        self.places = places
        
        tableView.reloadData()
    }
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = places[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.isHidden = true
        
        let place = places[indexPath.row]
        
        let marker = GMSMarker()
        
        GooglePlacesManager.shared.resolveLocation(for: place) { [weak self] result in
            
            switch result {
                
            case .success(let coordinate):
                
                DispatchQueue.main.async {
                    self?.delegate?.didTapPlace(with: coordinate, marker: marker)
                }
            
            case .failure(let error):
                print(error)
            }
        }
    }
}
