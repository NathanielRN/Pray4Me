//
//  PrayerFeelingPickerController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-10.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

protocol FeelingPickerTableViewControllerDelegate: class {
	func feelingPickerController(_ controller: PrayerFeelingPickerController, didSelectFeeling feelingPicked: String)
}

class PrayerFeelingPickerController: UITableViewController {

	var selectedIndex: Int?
	weak var delegateToHandleFeelingChoice: FeelingPickerTableViewControllerDelegate?
	var feelingChoice: String = "Global Feed"

    override func viewDidLoad() {
        super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = false
		selectedIndex = (PrayerFeeling.feelings as Array).index(of: self.feelingChoice)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrayerFeeling.feelings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeelingCell", for: indexPath)
		cell.textLabel?.text = PrayerFeeling.feelings[indexPath.row]

		if (indexPath.row == selectedIndex){
			cell.accessoryType = UITableViewCellAccessoryType.checkmark
		} else {
			cell.accessoryType = UITableViewCellAccessoryType.none
		}
        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		if selectedIndex != NSNotFound {
			let cell = tableView.cellForRow(at: NSIndexPath(row: selectedIndex!, section: 0) as IndexPath)
			cell?.accessoryType = UITableViewCellAccessoryType.none
		}
		self.selectedIndex = indexPath.row
		let cell = tableView.cellForRow(at: indexPath)
		cell?.accessoryType = UITableViewCellAccessoryType.checkmark
		let chosenFeeling = PrayerFeeling.feelings[indexPath.row]
		self.delegateToHandleFeelingChoice?.feelingPickerController(self, didSelectFeeling: chosenFeeling)
	}

}
