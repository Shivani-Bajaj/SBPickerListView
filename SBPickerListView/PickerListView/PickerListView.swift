//
//  PickerListView.swift
//
//
//  Created by Shivani.Bajaj on 25/02/20.
//  Copyright © 2020 6rbApp. All rights reserved.
//

import UIKit

protocol PickerListViewDelegate: class {
    func selected(value: PickerListDisplayable, for component: Int, with row: Int)
    func selected(values: [PickerListDisplayable?])
}

protocol PickerListDisplayable {
    var title: String { get }
}

enum PickerListType {
    case songs
}

class PickerListView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet internal var contentView: UIView!
    @IBOutlet internal weak var btnDone: UIButton!
    @IBOutlet internal weak var pickerObj: UIPickerView!
    @IBOutlet internal weak var viewWithPicker: UIView!
    @IBOutlet internal weak var headingLabel: UILabel!
    @IBOutlet internal weak var filterByButton: UIButton!
    
    // MARK: - Variables
    
    private var selectedPickerListType = PickerListType.songs
    private var lists = [[PickerListDisplayable]]()
    
    // MARK: - Variables Received
    
    weak var delegate: PickerListViewDelegate?

    // MARK: - Initialization
    
    init(with frame: CGRect,
         selectedType: PickerListType,
         selectedValues: [PickerListDisplayable?]?, lists: [[PickerListDisplayable]]) {
        super.init(frame: frame)
        selectedPickerListType = selectedType
        setup()
        switch selectedPickerListType {
        case .songs:
            self.lists = lists
            if let selectedValues = selectedValues, selectedValues.count == lists.count {
                for i in 0..<lists.count {
                    if let value = selectedValues[i] {
                        if let selectedIndex = lists[i].firstIndex(where: { $0.title == value.title }) {
                            pickerObj.selectRow(selectedIndex, inComponent: i, animated: true)
                        }
                    }
                }
            }
            headingLabel.text = ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        Bundle.main.loadNibNamed("PickerListView", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        btnDone.setTitle("Done", for: .normal)
        btnDone.addTarget(self, action: #selector(done), for: .touchUpInside)
        let tapGestureObj = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureObj.delegate = self
        addGestureRecognizer(tapGestureObj)
        pickerObj.dataSource = self
        pickerObj.delegate = self
    }
    
    func removeView() {
        self.removeFromSuperview()
    }
    
    // MARK: Helper Methods
    
    func setFilterText(_ val: String) {
        filterByButton.setTitle(val, for: .normal)
    }
    
    func setHeading(_ val: String) {
        headingLabel.text = val
    }
    
    func setHeadingColor(_ color: UIColor) {
        headingLabel.textColor = color
    }
    
    func setFilterAndDoneColor(_ color: UIColor) {
        filterByButton.setTitleColor(color, for: .normal)
        btnDone.setTitleColor(color, for: .normal)
    }
    
    // MARK: - IBActions
    
    @objc func done() {
        var values = [PickerListDisplayable?]()
        for i in 0..<lists.count {
            let selectedRow = pickerObj.selectedRow(inComponent: i)
            values.append(lists[i][selectedRow])
        }
        delegate?.selected(values: values)
        self.removeView()
    }
    
    @objc func viewTapped() {
        self.removeView()
    }
}

// MARK: - UIPickerViewDataSource

extension PickerListView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return lists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lists[component].count
    }
}

// MARK: - UIPickerViewDelegate

extension PickerListView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.selected(value: lists[component][row], for: component, with: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = lists[component][row].title
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23)])
    }
}

// MARK: - UIGestureRecognizerDelegate

extension PickerListView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view,
            touchedView == viewWithPicker {
            return false
        }
        return true
    }
}
