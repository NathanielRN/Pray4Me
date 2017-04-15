//
//  FeedFilterTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-14.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

protocol FilterFeedChangedProtocol: class {
	func filterAndReloadFeed(_ controller: FeedFilterTableViewController, filterToApply filterInex: Int) -> Void
}

class FeedFilterTableViewController: UITableViewController {

	var selectedFilterSettingRow = 0
	weak var delegateForFilteringFeed: FilterFeedChangedProtocol?

	override func viewDidLoad() {
		super.viewDidLoad()
		self.clearsSelectionOnViewWillAppear = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)
		if selectedFilterSettingRow != NSNotFound {
			let cell = tableView.cellForRow(at: NSIndexPath(row: selectedFilterSettingRow, section: 0) as IndexPath)
			cell?.accessoryType = UITableViewCellAccessoryType.none
		}
		self.selectedFilterSettingRow = indexPath.row
		let cell = tableView.cellForRow(at: indexPath)
		cell?.accessoryType = UITableViewCellAccessoryType.checkmark
		self.delegateForFilteringFeed?.filterAndReloadFeed(self, filterToApply: self.selectedFilterSettingRow)
	}
}
