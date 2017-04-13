//
//  PrayerFeedControllerTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-04.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class PrayerFeedTableViewController: UITableViewController, RequestDetailsDelegate {

	let noPrayersPrayer = PrayerRequest()
	var prayerRequestsSource = AppDelegate.appDelegate().prayerRequests.prayers

	func requestDetailsDidSubmit(_ controller: RequestDetailsTableViewController) {
		//self.prayerRequestsSource.prayerRequests.append(prayer)
//		let indexPath = [IndexPath(row: self.prayerRequestsSource.count - 1, section: 0)]
//		self.tableView.insertRows(at: indexPath, with: UITableViewRowAnimation.automatic)
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

	override func viewWillAppear(_ animated: Bool) {
		tableView.reloadData()
	}
	@IBAction func reloadFeedData(_ sender: Any) {
		AppDelegate.appDelegate().prayerRequests.prayers = []
		AppDelegate.appDelegate().prayerRequests.importPrayerFeed() { [weak self] in
			guard let `self` = self else { return }
			//print("Sum of times: \(time1 + time2)")
			self.prayerRequestsSource = AppDelegate.appDelegate().prayerRequests.prayers
			if self.prayerRequestsSource.isEmpty {
				self.noPrayersPrayer.requestString = "No prayers available! Please check your connection or come back later! :)"
				self.noPrayersPrayer.userAvatar = nil
				self.prayerRequestsSource = [self.noPrayersPrayer]
			}
			self.tableView.reloadData()
		}
	}
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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

	func deleteThePrayer(thePrayer: PrayerRequest) {
		AppDelegate.appDelegate().prayerRequests.deletePrayerFromServer(prayerToBeDeleted: thePrayer)
	}
}
