//
//  StartToWalkPageViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit
import GoogleMaps
import MapKit

class StartToWalkPageViewController: UIViewController {

    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var currentSteps: UILabel!
    
    @IBOutlet weak var currentduration: UILabel!
    
    @IBOutlet weak var currentDistance: UILabel!
    
    @IBOutlet weak var currentRouteMap: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentRouteMap.layer.cornerRadius = 20
        
        finishButton.layer.cornerRadius = 20
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
