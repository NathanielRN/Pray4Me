//
//  File.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-04-03.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import Foundation



struct FacebookUserInfo {
	var userName: String?
	var userProfilePicture: UIImage?
	var userEmail: String?
	var userFriendsIDArray: [String]?
	var userID: String?
}

class FacebookUser {

	static var sharedInstanceOfMe: FacebookUserInfo = FacebookUserInfo(userName: nil, userProfilePicture: nil, userEmail: nil, userFriendsIDArray: nil, userID: nil)
}
