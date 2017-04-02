//
//  Pray4MeLoginViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-01.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class Pray4MeLoginViewController: UIViewController, FBSDKLoginButtonDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()

//		if (FBSDKAccessToken.current() != nil) {
//			let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//			let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "Startup") as UIViewController
//			self.present(vc, animated: true, completion: nil)
//		}

//		let loginButton: FBSDKLoginButton = FBSDKLoginButton()
//		loginButton.center = self.view.center
//		self.view.addSubview(loginButton)
//		loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//		loginButton.delegate = self
        // Do any additional setup after loading the view.
    }

	override func viewDidAppear(_ animated: Bool) {
		if (FBSDKAccessToken.current() != nil) {
			self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
			return
		}
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

		if error == nil {
			self.performSegue(withIdentifier: "LoggedInSegue", sender: nil)
		}
	}
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
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
