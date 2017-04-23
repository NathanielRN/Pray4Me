//
//  PrayerFeedControllerTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-04.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class PrayerFeedTableViewController: UITableViewController, RequestDetailsDelegate, FilterFeedChangedProtocol {

	let noPrayersPrayer = PrayerRequest()
	var prayerRequestsSource = AppDelegate.appDelegate().serverConnectionInstance.prayers
	var refreshTableData: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 60
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	override func viewWillAppear(_ animated: Bool) {
		if self.prayerRequestsSource.isEmpty {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
				guard let `self` = self else { return}
				self.importAndRefreshTable()
			}
		}
	}

	@IBAction func pullToReloadFeed(_ sender: UIRefreshControl) {
		self.importAndRefreshTable(didPullToRefresh: sender)
	}

	@IBAction func subscribeToPrayer(_ sender: Any) {

		var superView = (sender as AnyObject).superview

		while type(of: (superView!)!) != PrayerRequestCell.self
		{
			NSLog("Lol I'm stuck \(type(of: (superView!)!))")
			superView = (superView as AnyObject).superview
		}

		let cell = superView as! UITableViewCell
		let indexPath = self.tableView.indexPath(for: cell)! as NSIndexPath
		let prayerToSubscribeTo = self.prayerRequestsSource[indexPath.row]
		AppDelegate.appDelegate().serverConnectionInstance.subscribeToPrayer(prayerToSubscribeTo: prayerToSubscribeTo) { [weak self] in
			guard let `self` = self else {return}
			self.tableView.reloadData()
		}
	}


	func importAndRefreshTable(didPullToRefresh refreshSender: UIRefreshControl? = nil) {
		self.prayerRequestsSource = []
		DispatchQueue.global(qos: .userInitiated).async {
			// Do long running task here
			// Bounce back to the main thread to update the UI
			AppDelegate.appDelegate().serverConnectionInstance.importPrayerFeed() { [weak self] in
				DispatchQueue.main.async {
					guard let `self` = self else { return }
					self.prayerRequestsSource = AppDelegate.appDelegate().serverConnectionInstance.prayers
					self.tableView.reloadData()
					if let pulledToRefresh = refreshSender {
						pulledToRefresh.endRefreshing()
					}
				}
			}
		}
	}
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		if !prayerRequestsSource.isEmpty {
			self.tableView.backgroundView = nil
			self.tableView.separatorStyle = .singleLine
			return 1;

		} else {
			// Display a message when the table is empty
			let noPrayersMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))

			noPrayersMessageLabel.text = "No prayers are currently available! Please pull down to refresh."
			noPrayersMessageLabel.textColor = UIColor.black
			noPrayersMessageLabel.numberOfLines = 0;
			noPrayersMessageLabel.textAlignment = .center
			noPrayersMessageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
			noPrayersMessageLabel.sizeToFit()

			self.tableView.backgroundView = noPrayersMessageLabel
			self.tableView.separatorStyle = .none;
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prayerRequestsSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: PrayerRequestCell = tableView.dequeueReusableCell(withIdentifier: "PrayerRequestCell")! as! PrayerRequestCell
		let prayer: PrayerRequest? = self.prayerRequestsSource[indexPath.row]
		cell.userNameLabel.text = prayer?.userName
		cell.requestLabel.text = prayer?.requestString
		if let profilePictureID = prayer?.userID {
			let fbProfileImageURL = URL(string: "http://graph.facebook.com/\(String(describing: profilePictureID))/picture?type=square")
			if let imageData = try? Data(contentsOf: fbProfileImageURL!) {
				cell.userAvatar.image = UIImage(data: imageData)
			}
		}
		cell.feelingLabel.text = prayer?.userFeeling
		return cell
    }

	
	// Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			self.deleteThePrayer(thePrayer: self.prayerRequestsSource[indexPath.row])
			self.prayerRequestsSource.remove(at: indexPath.row) // Delete the row from the data source
			if self.prayerRequestsSource.isEmpty {
				let multipleindexes = NSMutableIndexSet()
				multipleindexes.add(indexPath.section)
				tableView.beginUpdates()
				tableView.deleteRows(at: [indexPath], with: .fade)
				tableView.deleteSections(multipleindexes as IndexSet, with: .fade)
				tableView.endUpdates()
				return
			} else {
				tableView.deleteRows(at: [indexPath], with: .fade) // Delete the row on the table
			}
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
	}


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "RequestDetailsSegue" {
			let navigationController = segue.destination
			let prayerDetailsViewController = navigationController.childViewControllers[0] as! RequestDetailsTableViewController
			prayerDetailsViewController.delegateForSaveAndCancel = self
		} else if segue.identifier == "FilterFeedSegue" {
			let navigationController = segue.destination
			let prayerDetailsViewController = navigationController.childViewControllers[0] as! FeedFilterTableViewController
			prayerDetailsViewController.delegateForFilteringFeed = self
		}
    }

	func deleteThePrayer(thePrayer: PrayerRequest) {
		AppDelegate.appDelegate().serverConnectionInstance.deletePrayerFromServer(prayerToBeDeleted: thePrayer)
	}

	// MARK: RequestDetailsDelegate

	func requestDetailsDidSubmit(_ controller: RequestDetailsTableViewController, thePrayer: PrayerRequest) {
		AppDelegate.appDelegate().serverConnectionInstance.savePrayerToServer(prayerToBeSent: thePrayer) {
			self.importAndRefreshTable() }
		controller.dismiss(animated: true, completion: { _ in })
	}

	func requestDetailsDidCancel(_ controller: RequestDetailsTableViewController) {
		controller.dismiss(animated: true, completion: { _ in })
	}

	// MARK: FilterFeedChangedProtocol

	func filterAndReloadFeed(_ controller: FeedFilterTableViewController, filterToApply filterIndex: Int) {
		// Filter the feed
		controller.dismiss(animated: true)
	}
}
