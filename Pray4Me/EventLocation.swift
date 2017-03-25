//
//  EventLocation.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-18.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import Foundation

@objc class EventLocation: NSObject {
	private var title: String
	private var latitude: Double
	private var longitude: Double
	public init(title: String, latitude: Double, longitude: Double) {
		self.title = title
		self.latitude = latitude
		self.longitude = longitude
	}
}
