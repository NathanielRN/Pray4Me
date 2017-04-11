//
//  LoggedOutViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-02.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class LoggedOutViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

		let loginButton: FBSDKLoginButton = FBSDKLoginButton()
		loginButton.center = self.view.center
		self.view.addSubview(loginButton)
		loginButton.readPermissions = ["public_profile", "email", "user_friends"]
		loginButton.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	func loginButton(_ didCompleteWithloginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){

		self.dismiss(animated: true, completion: nil)
	}

	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
	}

}
