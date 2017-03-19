//
//  CalendarEvent.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-18.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import Foundation

@objc class CalendarEvent: NSObject {
	private(set) var title: String
	private(set) var startDate: Date
	private(set) var endDate: Date
	public init(title: String, startDate: Date, endDate: Date) {
		self.title = title
		self.startDate = startDate
		self.endDate = endDate
	}
}
