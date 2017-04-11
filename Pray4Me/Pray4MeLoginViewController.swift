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
    }

	override func viewDidAppear(_ animated: Bool) {

		// Must perform in view Did appear because the window isn't loaded onto the hierarchy until this point!
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

	override func viewWillDisappear(_ animated: Bool) {
		let currentUserRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, name, picture, friends, id"])
		_ = currentUserRequest?.start(completionHandler: { connection, result, error in

			if error == nil {
				print("Got 'em: \(String(describing: result))")
				//Must write to original shared instance and can't just assign instance to variable bc variable gets destroyed when leaving scope!
				FacebookUser.sharedInstanceOfMe.userName = (result as AnyObject)["name"]! as? String
				FacebookUser.sharedInstanceOfMe.userEmail = (result as AnyObject)["email"]! as? String
				FacebookUser.sharedInstanceOfMe.userProfilePicture = UIImage(data: NSData(contentsOf: NSURL(string: ((((result as AnyObject)["picture"] as AnyObject)["data"] as AnyObject)["url"]! as? String)!)! as URL)! as Data)
				FacebookUser.sharedInstanceOfMe.userID = (result as AnyObject)["id"]! as? String
				//FacebookUser.sharedInstanceOfMe.userFriendsArray = (result as AnyObject)["name"]! as? String

			}
		}
		)
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
