//
//  PickerTestFieldManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/2.
//
//

import UIKit

typealias PickerTestFieldDisplayNameHandler = ((String) -> String)
typealias PickerTestFidleItemSelectionHandler = ((Int, String) -> Void)

final class PickerTestField: UITextField {
    
    private let pickerView = UIPickerView(frame: .zero)
    private var lastYearSelectedRow: Int = 0
    private var lastMonthSelectedRow: Int = 0
    
    public var pickerYear: [String] = []
    public var pickerMonth: [String] = []
    public var displayNameHandle: PickerTestFieldDisplayNameHandler?
    public var itemSelectionHandler: PickerTestFidleItemSelectionHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.inputView = self.pickerView
    }
    
    private func updateTest() {
        
        let yearData = self.pickerYear[lastYearSelectedRow]
        let monthData = self.pickerMonth[lastMonthSelectedRow]
        self.text = self.displayNameHandle?("\(yearData) \(monthData)")
    }
}

extension PickerTestField: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let data = self.pickerYear[row]
            return self.displayNameHandle?(data)
        } else {
            let data = self.pickerMonth[row]
            return self.displayNameHandle?(data)
        }
    }
}

extension PickerTestField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            
            return self.pickerYear.count
        }
        
        return self.pickerMonth.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            
            self.lastYearSelectedRow = row
            self.updateTest()
            let data = self.pickerYear[row]
            self.itemSelectionHandler?(row, data)
            
        } else if component == 1 {
            
            self.lastMonthSelectedRow = row
            self.updateTest()
            let data = self.pickerMonth[row]
            self.itemSelectionHandler?(row, data)
        }
    }
}


//import UIKit
//
//typealias PickerTestFieldDisplayNameHandler = ((String) -> String)
//typealias PickerTestFidleItemSelectionHandler = ((Int, String) -> Void)
//
//final class PickerTestField: UITextField, UITextFieldDelegate {
//
//    private let pickerView = UIPickerView(frame: .zero)
//    private var lastYearSelectedRow: Int = 0
//    private var lastMonthSelectedRow: Int = 0
//
//    public var pickerYear: [String] = []
//    public var pickerMonth: [String] = []
//    public var displayNameHandle: PickerTestFieldDisplayNameHandler?
//    public var itemSelectionHandler: PickerTestFidleItemSelectionHandler?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.configureView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.configureView()
//    }
//
//    private func configureView() {
//        self.pickerView.delegate = self
//        self.pickerView.dataSource = self
//        self.inputView = self.pickerView
//    }
//
//    private func updateTest() {
//
//        let yearData = self.pickerYear[lastYearSelectedRow]
//        let monthData = self.pickerMonth[lastMonthSelectedRow]
//        self.text = self.displayNameHandle?(" \(monthData)  \(yearData)")
//    }
//}
//
//extension PickerTestField: UIPickerViewDelegate {
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if component == 0 {
//
//            let data = self.pickerMonth[row]
//            return self.displayNameHandle?(data)
//        } else {
//
//            let data = self.pickerYear[row]
//            return self.displayNameHandle?(data)
//        }
//    }
//}
//
//extension PickerTestField: UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 2
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 {
//
//            return self.pickerMonth.count
//        }
//
//        return self.pickerYear.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        if component == 0 {
//
//            self.lastMonthSelectedRow = row
//            self.updateTest()
//            let data = self.pickerMonth[row]
//            self.itemSelectionHandler?(row, data)
//        } else if component == 1 {
//
//            self.lastYearSelectedRow = row
//            self.updateTest()
//            let data = self.pickerYear[row]
//            self.itemSelectionHandler?(row, data)
//        }
//    }
//}
