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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

	override func viewWillAppear(_ animated: Bool) {
		self.importSubscribedPrayers()
	}

	func importSubscribedPrayers() {
		self.prayersYouSubscribeTo = []
		DispatchQueue.global(qos: .userInitiated).async {
			AppDelegate.appDelegate().prayerRequests.importSubscribedPrayers() {
				DispatchQueue.main.async { [weak self] in
					guard let `self` = self else { return }
					self.prayersYouSubscribeTo = AppDelegate.appDelegate().prayerRequests.subscribedPrayers
					self.tableView.reloadData()
				}

			}
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
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

}
