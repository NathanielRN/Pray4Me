//
//  CalendarViewController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-19.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit
import EventKit

class CalendarViewController: UIViewController, PrayerCalendarViewDelegate, PrayerCalendarViewDataSource {

	@IBOutlet weak var calendarView: PrayerCalendarView!
//	@IBOutlet weak var datePicker: UIDatePicker!

	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		calendarView.collectionDataSource = self
		calendarView.prayerDelegate = self
		self.loadEventsInCalendar()
		// change the code to get a vertical calender.
		calendarView.direction = .horizontal
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		
		var tomorrowComponents = DateComponents()
		tomorrowComponents.day = 1
		
		let today = Date()
		
		
		if let tomorrow = (self.calendarView.calendar as NSCalendar).date(byAdding: tomorrowComponents, to: today, options: NSCalendar.Options()) {
			self.calendarView.selectDate(tomorrow)
			//self.calendarView.deselectDate(date)
			
		}
		
		self.calendarView.setDisplayDate(today, animated: false)
		//self.datePicker.setDate(today, animated: false)
		
		
	}
	
	// MARK : KDCalendarDataSource
	
	func startDate() -> Date? {
		
		var dateComponents = DateComponents()
		dateComponents.month = -3
		
		let today = Date()
		
		let threeMonthsAgo = (self.calendarView.calendar as NSCalendar).date(byAdding: dateComponents, to: today, options: NSCalendar.Options())
		
		
		return threeMonthsAgo
	}
	
	func endDate() -> Date? {
		
		var dateComponents = DateComponents()
		
		dateComponents.year = 2;
		let today = Date()
		
		let twoYearsFromNow = (self.calendarView.calendar as NSCalendar).date(byAdding: dateComponents, to: today, options: NSCalendar.Options())
		
		return twoYearsFromNow
  
	}
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		
//		let width = self.view.frame.size.width - 16.0 * 2
//		let height = width + 20.0
//		self.calendarView.frame = CGRect(x: 16.0, y: 32.0, width: width, height: height)
		
	}

	// MARK : KDCalendarDelegate
	
	func calendar(_ calendar: PrayerCalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
		
		for event in events {
			print("You have an event starting at \(event.startDate) : \(event.title)")
			self.tableViewController.eventsArraySource.eventsArray.append(event.title)
			let indexPath = [IndexPath(row: self.tableViewController.eventsArraySource.eventsArray.count - 1, section: 0)]
			self.tableViewController.prayerEvents?.insertRows(at: indexPath, with: UITableViewRowAnimation.automatic)
		}
		print("Did Select: \(date) with Events: \(events.count)")
		
		
	}
	
	func calendar(_ calendar: PrayerCalendarView, didScrollToMonth date : Date) {
		
		//self.datePicker.setDate(date, animated: true)

	}
	
	// MARK : Events
	
	func loadEventsInCalendar() {
		
		if let  startDate = self.startDate(),
			let endDate = self.endDate() {
			
			let store = EKEventStore()
			
			let fetchEvents = { () -> Void in
				
				let predicate = store.predicateForEvents(withStart: startDate, end:endDate, calendars: nil)
				
				// if can return nil for no events between these dates
				if let eventsBetweenDates = store.events(matching: predicate) as [EKEvent]? {
					
					self.calendarView.events = eventsBetweenDates
					
				}
				
			}
			
			// let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
			
			if EKEventStore.authorizationStatus(for: EKEntityType.event) != EKAuthorizationStatus.authorized {
				
				store.requestAccess(to: EKEntityType.event, completion: {(granted, error ) -> Void in
					if granted {
						fetchEvents()
					}
				})
				
			}
			else {
				fetchEvents()
			}
			
		}
		
	}
	
	var tableViewController: PrayerEventsTableViewController!

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let segueName = segue.identifier
		if segueName == "eventSegue" {
			tableViewController = segue.destination as! PrayerEventsTableViewController
			self.addChildViewController(tableViewController)
			tableViewController.didMove(toParentViewController: self)
		}
	}
}
