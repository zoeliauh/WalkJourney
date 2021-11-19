//
//  FunnyMapViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit

class FunnyMapViewController: UIViewController {
        
    lazy var funnyMapTableView: UITableView = {
        
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.register(FunnyMapTableViewCell.self, forCellReuseIdentifier: FunnyMapTableViewCell.identifier)
        table.reloadData()

        return table
    }()
    
    var shapeMapExample = ShapeMapExample()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFunnyMapTableView()
        
        funnyMapTableView.delegate = self
        
        funnyMapTableView.dataSource = self
        
        self.tabBarController?.tabBar.backgroundImage =  UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupFunnyMapTableView() {
        
        view.addSubview(funnyMapTableView)
        
        funnyMapTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            funnyMapTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            funnyMapTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            funnyMapTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            funnyMapTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FunnyMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shapeMapExample.shapeArr.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = funnyMapTableView.dequeueReusableCell(
            withIdentifier: "FunnyMapTableViewCell", for: indexPath
        ) as? FunnyMapTableViewCell else { fatalError("can not dequeue cell") }
        
        cell.shapeImageView.image = shapeMapExample.shapeArr[indexPath.row]
        
        cell.goButton.tag = indexPath.row
        
        cell.goButton.addTarget(self, action: #selector(goButtonPressed(_:)), for: .touchUpInside)
        
        cell.selectionStyle = .none
                
        return cell
    }
    
    @objc func goButtonPressed(_ sender: UIButton!) {
        guard let googleArtPagevc = UIStoryboard.position.instantiateViewController(
            withIdentifier: "GoogleArtPage"
        ) as? GoogleArtViewController else { return }
        
        googleArtPagevc.routeSampleImageView.image = shapeMapExample.lineArr[sender.tag]
        
        self.navigationController?.pushViewController(googleArtPagevc, animated: true)
    }
}
