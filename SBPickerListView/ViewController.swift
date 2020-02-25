//
//  ViewController.swift
//  SBPickerListView
//
//  Created by shivani Bajaj on 2/25/20.
//  Copyright © 2020 Shivani Bajaj. All rights reserved.
//

import UIKit

struct SongType: PickerListDisplayable {
    var title: String
}

struct Time: PickerListDisplayable {
    var title: String
}

class ViewController: UIViewController {

    // MARK: Variables and Constants
    
    var pickerList: PickerListView?
    var songTypes = [SongType(title: "English songs"), SongType(title: "Hindi songs"), SongType(title: "Punjabi songs"), SongType(title: "Spanish songs"), SongType(title: "Arabic songs"), SongType(title: "Mega mix")]
    var sortTimes = [Time(title: "Day"), Time(title: "Week"), Time(title: "Month"), Time(title: "Year"), Time(title: "2 weeks"), Time(title: "3 months"), Time(title: "6 months"), Time(title: "9 months")]
    var selectedValues = [PickerListDisplayable?](repeating: nil, count: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func testPicker(_ sender: Any) {
        pickerList = PickerListView(with: self.view.bounds, selectedType: .songs, selectedValues: selectedValues, lists: [songTypes, sortTimes])
        pickerList?.delegate = self
        pickerList?.setHeading("Songs")
        view.addSubview(pickerList!)
    }
}

// MARK: PickerView Delegate Methods

extension ViewController: PickerListViewDelegate {
    func selected(values: [PickerListDisplayable?]) {
        selectedValues = values
    }
    
    func selected(value: PickerListDisplayable, for component: Int, with row: Int) {
        
    }
}


