//
//  StartToWalkPageViewController.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/10/19.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore
import CoreMotion

class StartToWalkPageViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var currentSteps: UILabel!
    
    @IBOutlet weak var currentduration: UILabel!
    
    @IBOutlet weak var currentDistance: UILabel!
    
    @IBOutlet weak var currentRouteMap: GMSMapView!
        
    var db: Firestore!
    
    var currentLocation = [Double]()
            
    let marker = GMSMarker()
    
    let activityManager = CMMotionActivityManager()
    
    let pedometer = CMPedometer()
    
    var timer = Timer()
    
    var count: Int = 0
        
    var stepsTab: [StepData] = []
    
    let stepData = StepData(numberOfSteps: 0, durationOfTime: "", distanceOfWalk: "", date: "", time: "")
    
    var timeString: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        countTimer()
                                
        loadData()
                
        countSteps()
                
        currentRouteMap.layer.cornerRadius = 20
        
        finishButton.layer.cornerRadius = 20
        
        defaultPosition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
            
            self.timer.invalidate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        defaultPosition()
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func timerCounter() {
        
        count += 1
        
        let time = secondToSecMinHour(seconds: count)
        
        timeString = makeTimeString(hour: time.0, min: time.1, sec: time.2)
        
        currentduration.text = timeString
    }
    
    func defaultPosition() {
        
        var camera = GMSCameraPosition()
                
//        if currentLocation.count == 2 {
//
//        camera = GMSCameraPosition.camera(withLatitude: currentLocation[0], longitude: currentLocation[1], zoom: 16)
//
//            marker.position = CLLocationCoordinate2D(latitude: currentLocation[0], longitude: currentLocation[2])
//        }
        
        camera = GMSCameraPosition.camera(withLatitude: 23.5, longitude: 123.5, zoom: 16)
            
            currentRouteMap.delegate = self
            
            currentRouteMap.camera = camera
                                                
            marker.map = currentRouteMap
            
            currentRouteMap.settings.myLocationButton = true
                    
            currentRouteMap.isMyLocationEnabled = true
    }
    
    func countTimer() {
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    func loadData() {
        
        db.collection("steps").order(by: "Number of steps")
            .addSnapshotListener { (querySnapshot, error) in
            
            self.stepsTab = []
            
            if let error = error {
                print("Problem wit loading data. \(error)")
            } else {
                if let snapshotdoc = querySnapshot?.documents {
                    for doc in snapshotdoc {
                        let data = doc.data()
                        if let numberOfSteps = data["Number of steps"] as? Int, let date = data["Date"] as? String, let time = data["Time"] as? String {
                            let newStepData = StepData(numberOfSteps: numberOfSteps, durationOfTime: self.timeString, distanceOfWalk: numberOfSteps.description, date: date, time: time)
                            self.stepsTab.append(newStepData)
                            
                            DispatchQueue.main.async {
                                self.currentSteps.reloadInputViews()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func countSteps() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { (data, error) in
                if error == nil {
                    if let response = data {
                        DispatchQueue.main.async {
                            print("STEPS : \(response.numberOfSteps)")
                            self.currentSteps.text = response.numberOfSteps.stringValue
                            let testPack = self.createPack()
                            print(testPack)
                            self.sendPack(pack: testPack)
                        }
                    }
                }
            }
        }
    }
    
    func createPack() -> StepData {
        
        let date = Date()
        let calendar = Calendar.current
        
        if let text = self.currentSteps.text, let stepValue = Int(text) {
            
            let yearCur = calendar.component(.year, from: date)
            let monthCur = calendar.component(.month, from: date)
            let dayCur = calendar.component(.day, from: date)
            let hourCur = calendar.component(.hour, from: date)
            let minutesCur = calendar.component(.minute, from: date)
            let secondsCur = calendar.component(.second, from: date)
            
            let dateCur = "\(dayCur).\(monthCur).\(yearCur)"
            let timeCur = "\(hourCur):\(minutesCur):\(secondsCur)"
            
            return StepData(numberOfSteps: stepValue, durationOfTime: stepValue.description, distanceOfWalk: stepValue.description, date: dateCur, time: timeCur)
        }
        return StepData(numberOfSteps: 0, durationOfTime: "00 : 00", distanceOfWalk: "0", date: "00.00.0000", time: "00:00")
    }
    
    func sendPack(pack: StepData) {
        db.collection("steps").addDocument(data:
            ["Number of steps": pack.numberOfSteps,
             "Duration of time": pack.durationOfTime,
             "Distance of walk": pack.distanceOfWalk,
             "Date": pack.date,
             "Time": pack.time
        ]) { (error) in
            if let error = error {
                print("Problem found : \(error)")
            } else {
                print("Data saved !!")
            }
        }
    }
    
    func secondToSecMinHour(seconds: Int) -> (Int, Int, Int) {
        
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hour: Int, min: Int, sec: Int) -> String {

        var timeString: String = ""

        timeString += String(format: "%02d", hour)
        timeString += " : "
        timeString += String(format: "%02d", min)
        timeString += " : "
        timeString += String(format: "%02d", sec)
        return timeString
    }
}
