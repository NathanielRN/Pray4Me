//
//  RequestDetailsTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-05.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

protocol RequestDetailsDelegate: class {
	
	func requestDetailsDidCancel (_ controller: RequestDetailsTableViewController)
	func requestDetailsDidSubmit (_ controller: RequestDetailsTableViewController, didAddPrayer prayer: PrayerRequest)
}

class RequestDetailsTableViewController: UITableViewController, FeelingPickerTableViewControllerDelegate {
	
	weak var delegateForSaveAndCancel: RequestDetailsDelegate?
	var feeling: String = "Thinking"
	
	@IBAction func cancel(_ sender: Any) {
		self.delegateForSaveAndCancel?.requestDetailsDidCancel(self)
	}

	@IBAction func done(_ sender: Any) {
		let prayer = PrayerRequest()
		prayer.requestString = self.prayerTextView.text
		prayer.userName = feeling
		self.delegateForSaveAndCancel?.requestDetailsDidSubmit(self, didAddPrayer: prayer)
	}

	
	@IBOutlet var prayerTextView: UITextView!
	@IBOutlet var userFeelingLabel: UILabel!
	
	func dismissKeyboard (){
		prayerTextView.endEditing(true)
		//prayerTextView.resignFirstResponder() Does the same thing apparently
	}
	
	func feelingPickerController(_ controller: PrayerFeelingPickerController, didSelectFeeling feelingPicked: String) {
		self.feeling = feelingPicked
		self.userFeelingLabel.text = self.feeling
		_ = self.navigationController?.popViewController(animated: true)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tapAwayFromTextView = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		self.view.addGestureRecognizer(tapAwayFromTextView)
		tapAwayFromTextView.cancelsTouchesInView = false
		
		//Making the TableViewController have an interactively enable keyboard gives it the swipedown capability

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

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if (indexPath.section == 0){
			self.prayerTextView.becomeFirstResponder()
		}
	}

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if segue.identifier == "PickFeeling" {
			let feelingPickerViewController = segue.destination as! PrayerFeelingPickerController
			feelingPickerViewController.delegateToHandleFeelingChoice = self
		}
    }

}
