//
//  ProfileTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-18.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

	var prayersYouSubscribeTo: [PrayerRequest] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		self.importSubscribedPrayers()
    }

	override func viewWillAppear(_ animated: Bool) {
		self.importSubscribedPrayers()
	}

	func importSubscribedPrayers() {
		self.prayersYouSubscribeTo = []
		DispatchQueue.global(qos: .userInitiated).async {
			AppDelegate.appDelegate().serverConnectionInstance.importSubscribedPrayers() {
				DispatchQueue.main.async { [weak self] in
					guard let `self` = self else { return }
					self.prayersYouSubscribeTo = AppDelegate.appDelegate().serverConnectionInstance.subscribedPrayers
					self.tableView.reloadData()
				}

			}
		}
	}

	@IBAction func unsubscribeFromPrayer(_ sender: Any) {
		var superView = (sender as AnyObject).superview

		while (type(of: (superView!)!)) != SubscribedPrayerTableViewCell.self {
			superView = (superView as AnyObject).superview
		}

		let tappedCell = superView as! UITableViewCell
		let indexPath = self.tableView.indexPath(for: tappedCell)! as IndexPath
		let prayerToUnsubscribeFrom = self.prayersYouSubscribeTo[indexPath.row]
		self.removePrayerFromModelSource(unsubscribeFrom: prayerToUnsubscribeFrom)
		self.prayersYouSubscribeTo.remove(at: indexPath.row) // Delete the row from the data source
		if self.prayersYouSubscribeTo.isEmpty {
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
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		if !prayersYouSubscribeTo.isEmpty {
			self.tableView.backgroundView = nil
			self.tableView.separatorStyle = .singleLine
			return 1;

		} else {
			// Display a message when the table is empty
			let noSubscriptionsYetLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))

			noSubscriptionsYetLabel.text = "You've finished praying for all you subscriptions! Go to your feed to subscribe to more prayers!."
			noSubscriptionsYetLabel.textColor = UIColor.black
			noSubscriptionsYetLabel.numberOfLines = 0;
			noSubscriptionsYetLabel.textAlignment = .center
			noSubscriptionsYetLabel.font = UIFont(name: "Palatino-Italic", size: 20)
			noSubscriptionsYetLabel.sizeToFit()

			self.tableView.backgroundView = noSubscriptionsYetLabel
			self.tableView.separatorStyle = .none;
			return 0
		}
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.prayersYouSubscribeTo.count
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscribedPrayer", for: indexPath) as! SubscribedPrayerTableViewCell
		let prayerToBeAdded = self.prayersYouSubscribeTo[indexPath.row]
		cell.prayerRequestField.text = prayerToBeAdded.requestString
		cell.userNameField.text = prayerToBeAdded.userName

		if let profilePictureID = prayerToBeAdded.userID {
			let fbProfileImageURL = URL(string: "http://graph.facebook.com/\(String(describing: profilePictureID))/picture?type=square")
			if let imageData = try? Data(contentsOf: fbProfileImageURL!) {
				cell.userAvatarField.image = UIImage(data: imageData)
			}
		}


        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	func removePrayerFromModelSource(unsubscribeFrom prayerToUnsubscribeFrom: PrayerRequest) {
		AppDelegate.appDelegate().serverConnectionInstance.unsubscribeFromPrayer(unsubscribeFrom: prayerToUnsubscribeFrom)
	}

}
