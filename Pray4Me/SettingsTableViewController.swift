//
//  SettingsTableViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-02.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

	@IBOutlet weak var settingsProfilePicture: UIImageView!
	@IBOutlet weak var settingsUserName: UILabel!
	@IBOutlet weak var settingsPrayingAboutTextField: UITextField!

	override func viewWillAppear(_ animated: Bool) {
		self.settingsProfilePicture.image = FacebookUser.sharedInstanceOfMe.userProfilePicture
		self.settingsUserName.text = FacebookUser.sharedInstanceOfMe.userName
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func logOutOfFacebook(_ sender: Any) {

		FBSDKLoginManager().logOut()
	}

}
