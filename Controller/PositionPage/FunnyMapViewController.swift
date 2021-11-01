//
//  FunnyMapViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit

struct ShapeMapExample {
    
    var shapeArr = [
        UIImage(named: "triangle_shape"),
        UIImage(named: "square_shape"),
        UIImage(named: "circle_shape")
        ]
}

class FunnyMapViewController: UIViewController {
    
    @IBOutlet weak var funnyMapTableView: UITableView!
    
    var shapeMapExample = ShapeMapExample()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funnyMapTableView.delegate = self
        
        funnyMapTableView.dataSource = self
    }
}

extension FunnyMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shapeMapExample.shapeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = funnyMapTableView.dequeueReusableCell(withIdentifier: "FunnyMapTableViewCell", for: indexPath) as? FunnyMapTableViewCell else { fatalError("can not dequeue cell") }
        
        cell.shapeImageView.image = shapeMapExample.shapeArr[indexPath.row]
        cell.goButton.tag = indexPath.row
        cell.goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)

        let selectedBackGroundView = UIView()
        cell.selectedBackgroundView = selectedBackGroundView
        cell.selectedBackgroundView?.backgroundColor = .clear
        
        return cell
    }
    
    @objc func goButtonPressed() {
        guard let mapSearchingPagevc = UIStoryboard.position.instantiateViewController(withIdentifier: "MapSearchingPage") as? MapSearchingPageViewController else { return }
        
        self.navigationController?.pushViewController(mapSearchingPagevc, animated: true)
    }
}
