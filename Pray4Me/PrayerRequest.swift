//
//  PrayerRequest.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-04.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class PrayerRequest: NSObject {

	override init() {
		super.init()
	}
	convenience init(dictionaryWithInfo: Dictionary<AnyHashable, Any>) {
		self.init()
		self.userName = dictionaryWithInfo["userName"] as? String
		self.requestString = dictionaryWithInfo["requestString"] as? String
		//self.userAvatar = dictionaryWithInfo["userAvatar"] as? UIImage
		self.userFeeling = dictionaryWithInfo["userFeeling"] as? String
		self.userID = dictionaryWithInfo["userID"] as? String
	}

	var userName: String?

	var requestString: String?

	var userAvatar: UIImage?

	var userFeeling: String?

	var userID: String?

	func convertToDictionary() -> [AnyHashable: Any] {
		var prayerAsDictionary = [String:Any]()
		prayerAsDictionary["userName"] = self.userName
		prayerAsDictionary["requestString"] = self.requestString
		//prayerAsDictionary["userAvatar"] = self.userAvatar
		prayerAsDictionary["userFeeling"] = self.userFeeling
		prayerAsDictionary["userID"] = self.userID
		return prayerAsDictionary
	}

}
