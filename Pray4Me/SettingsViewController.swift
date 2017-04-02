//
//  Settings.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-02-25.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class Settings: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

		let loginButton: FBSDKLoginButton = FBSDKLoginButton()
		loginButton.frame.origin.y = self.view.frame.midY + 100
		loginButton.frame.origin.x = self.view.frame.midX
		self.view.addSubview(loginButton)
		loginButton.readPermissions = ["public_profile", "email", "user_friends"]
		loginButton.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func loginButton(_ didCompleteWithloginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){

	}
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){

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
