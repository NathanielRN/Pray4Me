//
//  Settings.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-02-25.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class Settings: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



	@IBAction func logOutOfFacebook(_ sender: Any) {

		FBSDKLoginManager().logOut()
		let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Login") as UIViewController
		self.present(vc, animated: true, completion: nil)
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
