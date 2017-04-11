//
//  PrayerFeedControllerTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-04.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class PrayerFeedTableViewController: UITableViewController, RequestDetailsDelegate {

	var prayerRequestsSource = RequestsForPrayer()

	func requestDetailsDidSubmit(_ controller: RequestDetailsTableViewController, prayerToAdd prayer: PrayerRequest) {
		self.prayerRequestsSource.prayerRequests.append(prayer)
		let indexPath = [IndexPath(row: self.prayerRequestsSource.prayerRequests.count - 1, section: 0)]
		self.tableView.insertRows(at: indexPath, with: UITableViewRowAnimation.automatic)
		controller.dismiss(animated: true, completion: { _ in })
	}

	func requestDetailsDidCancel(_ controller: RequestDetailsTableViewController) {
		controller.dismiss(animated: true, completion: { _ in })
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prayerRequestsSource.prayerRequests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell: PrayerRequestCell = tableView.dequeueReusableCell(withIdentifier: "PrayerRequestCell")! as! PrayerRequestCell
		let prayer: PrayerRequest? = self.prayerRequestsSource.prayerRequests[indexPath.row]
		cell.userNameLabel.text = prayer?.userName
		cell.requestLabel.text = prayer?.requestString
		cell.userAvatar.image = prayer?.userAvatar
		cell.feelingLabel.text = prayer?.userFeeling
		return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			self.prayerRequestsSource.prayerRequests.remove(at: indexPath.row) // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade) // Delete the row on the table
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
	}


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "RequestDetailsSegue"){
			let navigationController = segue.destination
			let prayerDetailsViewController = navigationController.childViewControllers[0] as! RequestDetailsTableViewController
			prayerDetailsViewController.delegateForSaveAndCancel = self
			
		}
    }
}
