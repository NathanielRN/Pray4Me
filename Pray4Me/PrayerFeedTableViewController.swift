//
//  PrayerFeedControllerTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-04.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class PrayerFeedTableViewController: UITableViewController, RequestDetailsDelegate {
	
	var prayerRequests = [PrayerRequest]()
	
	func requestDetailsDidSubmit(_ controller: RequestDetailsTableViewController, didAddPrayer prayer: PrayerRequest) {
		self.prayerRequests.append(prayer)
		let indexPath = [IndexPath(row: self.prayerRequests.count - 1, section: 0)]
		self.tableView.insertRows(at: indexPath, with: UITableViewRowAnimation.automatic)
		self.dismiss(animated: true, completion: { _ in })
	}

	func requestDetailsDidCancel(_ controller: RequestDetailsTableViewController) {
		self.dismiss(animated: true, completion: { _ in })
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        // #warning Incomplete implementation, return the number of rows
        return self.prayerRequests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...

		let cell: PrayerRequestCell = tableView.dequeueReusableCell(withIdentifier: "PrayerRequestCell")! as! PrayerRequestCell
		let prayer: PrayerRequest? = self.prayerRequests[indexPath.row]
		cell.userNameLabel.text = prayer?.userName
		cell.requestLabel.text = prayer?.requestString
		cell.userAvatar.image = prayer?.userAvatar
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
            // Delete the row from the data source
			self.prayerRequests.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
	}

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

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if (segue.identifier == "RequestDetailsSegue"){
			let navigationController = segue.destination
			let prayerDetailsViewController = navigationController.childViewControllers[0] as! RequestDetailsTableViewController
			prayerDetailsViewController.delegate = self
			
		}
    }


}
