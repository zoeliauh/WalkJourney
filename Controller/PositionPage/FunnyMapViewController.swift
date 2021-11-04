//
//  FunnyMapViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit

class FunnyMapViewController: UIViewController {
    
    @IBOutlet weak var funnyMapTableView: UITableView!
    
    var shapeMapExample = ShapeMapExample()
    
    var tag: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        funnyMapTableView.delegate = self
        
        funnyMapTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        cell.goButton.addTarget(self, action: #selector(goButtonPressed(_:)), for: .touchUpInside)
                
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
