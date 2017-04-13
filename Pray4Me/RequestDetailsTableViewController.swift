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
	func requestDetailsDidSubmit (_ controller: RequestDetailsTableViewController, thePrayer: PrayerRequest)
}

class RequestDetailsTableViewController: UITableViewController, FeelingPickerTableViewControllerDelegate {

	weak var delegateForSaveAndCancel: RequestDetailsDelegate?
	var feeling: String = "No Feeling Selected"

	@IBAction func cancel(_ sender: Any) {
		self.delegateForSaveAndCancel?.requestDetailsDidCancel(self)
	}

	@IBAction func done(_ sender: Any) {
		let prayer = PrayerRequest()
		prayer.requestString = self.prayerTextView.text
		prayer.userName = FacebookUser.sharedInstanceOfMe.userName
		prayer.userAvatar = FacebookUser.sharedInstanceOfMe.userProfilePicture
		prayer.userFeeling = feeling
		prayer.userID = FacebookUser.sharedInstanceOfMe.userID
		self.delegateForSaveAndCancel?.requestDetailsDidSubmit(self, thePrayer: prayer)
	}

	@IBOutlet var prayerTextView: UITextView!
	@IBOutlet var userFeelingLabel: UILabel!

	func dismissKeyboard (){
		prayerTextView.endEditing(true)
		//prayerTextView.resignFirstResponder() Does the same thing apparently?
	}

	//MARK: - SuperClass Functions

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let tapAwayFromTextView = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		self.view.addGestureRecognizer(tapAwayFromTextView)
		tapAwayFromTextView.cancelsTouchesInView = false
		
		//Making the TableViewController have an interactively enabled keyboard gives it the swipedown capability

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

	//MARK: - Feeling Picker Delegate

	func feelingPickerController(_ controller: PrayerFeelingPickerController, didSelectFeeling feelingPicked: String) {
		self.feeling = feelingPicked
		self.userFeelingLabel.text = self.feeling
		_ = self.navigationController?.popViewController(animated: true)
	}

    // MARK: - Table view data source

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if (indexPath.section == 0){
			self.prayerTextView.becomeFirstResponder()
		}
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PickFeeling" {
			let feelingPickerViewController = segue.destination as! PrayerFeelingPickerController
			feelingPickerViewController.delegateToHandleFeelingChoice = self
		}
    }
}
