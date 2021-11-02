//
//  PickerTestFieldManager.swift
//  WalkJourney
//
//  Created by woanjwu liauh on 2021/11/2.
//

import UIKit

typealias PickerTestFieldDisplayNameHandler = ((Any) -> String)
typealias PickerTestFidleItemSelectionHandler = ((Int, Any) -> Void)

final class PickerTestField: UITextField {
    
    private let pickerView = UIPickerView(frame: .zero)
    private var lastSelectedRow: Int?
    
    public var pickerDates: [Any] = []
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
        
        if self.lastSelectedRow == nil {
            
            self.lastSelectedRow = 0
        }
        
        guard let lastSelectedRow = lastSelectedRow else { return }
        
        if lastSelectedRow > self.pickerDates.count {
            
            return
        }
        
        let data = self.pickerDates[lastSelectedRow]
        self.text = self.displayNameHandle?(data)
    }
}

extension PickerTestField: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    
        let data = self.pickerDates[row]
        return self.displayNameHandle?(data)
    }
}

extension PickerTestField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lastSelectedRow = row
        self.updateTest()
        let data = self.pickerDates[row]
        self.itemSelectionHandler?(row, data)
    }
}
