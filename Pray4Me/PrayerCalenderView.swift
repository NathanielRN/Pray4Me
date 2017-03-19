//
//  PrayerCalenderController.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-18.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//
// Original content provided by https://github.com/mmick66/CalendarView/blob/master/KDCalendar/CalendarView/CalendarView.swift
// All copyrights for the idea belong to the original creator mentioned above

import UIKit
import EventKit

let cellReuseIdentifier = "CalendarDayCell"

let numberOfDaysInWeek = 7
let maximumNumberOfRows = 6

let headerDefaultHeight: CGFloat = 80.0

let firstDayIndex = 0
let numberOfDaysIndex = 1
let dateSelectedIndex = 2



@objc protocol PrayerCalendarViewDataSource: class {
	func startDate() -> Date?
	func endDate() -> Date?
}

@objc protocol PrayerCalendarViewDelegate: class {
	@objc optional func calendar(_ calendar : PrayerCalendarView, canSelectDate date : Date) -> Bool
	func calendar(_ calendar : PrayerCalendarView, didScrollToMonth date : Date)
	func calendar(_ calendar: PrayerCalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) -> Void
	@objc optional func calendar(_ calendar : PrayerCalendarView, didDeselectDate date : Date)
}

extension EKEvent {
	var isOneDay: Bool {
		let components = (Calendar.current as NSCalendar).components([.era, .year, .month, .day], from: self.startDate, to: self.endDate, options: NSCalendar.Options())
		return (components.era == 0 && components.year == 0 && components.month == 0 && components.day == 0)
	}
}
class PrayerCalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
	
	weak var collectionDataSource: PrayerCalendarViewDataSource?
	weak var prayerDelegate: PrayerCalendarViewDelegate?
	
	lazy var gregorian: Calendar = {
		var cal = Calendar(identifier: Calendar.Identifier.gregorian)
		cal.timeZone = TimeZone(abbreviation: "UTC")!
		return cal
	}()
	
	var calendar: Calendar {
		return self.gregorian
	}
	
	var direction: UICollectionViewScrollDirection = .horizontal {
		didSet {
			if let layout = self.calendarView.collectionViewLayout as? CalendarFlowLayout {
				layout.scrollDirection = direction
				self.calendarView.reloadData()
			}
		}
	}
	
	private var startDateCache : NSDate = NSDate()
	private var endDateCache : NSDate = NSDate()
	private var startOfMonthCache : NSDate = NSDate()
	private var todayIndexPath : NSIndexPath?
	var displayDate: Date?
	
	fileprivate(set) var selectedIndexPaths : [IndexPath] = [IndexPath]()
	fileprivate(set) var selectedDates : [NSDate] = [NSDate]()

	fileprivate var eventsByIndexPath: [IndexPath:[CalendarEvent]] = [IndexPath:[CalendarEvent]]()
	var events: [EKEvent]? {
		
		didSet {
			eventsByIndexPath = [IndexPath:[CalendarEvent]]()
			
			guard let events = events else { return }
			
			let secondsFromGMTDifference = TimeInterval(NSTimeZone.local.secondsFromGMT())
			
			for event in events {
				
				guard event.isOneDay != false else { return } //This doesn't really make sense...
			
				
				let flags: NSCalendar.Unit = [NSCalendar.Unit.month, NSCalendar.Unit.day]
				
				let startDate = event.startDate.addingTimeInterval(secondsFromGMTDifference)
				let endDate = event.endDate.addingTimeInterval(secondsFromGMTDifference)
				
				let distanceFromStartComponent = (self.gregorian as NSCalendar).components(flags, from: startOfMonthCache as Date, to: startDate, options: NSCalendar.Options())
				
//				if let structured = event.structuredLocation {
//					_ = EventLocation(title: structured.title, latitude: (structured.geoLocation?.coordinate.latitude)!, longitude: (structured.geoLocation?.coordinate.longitude)!)
//				}
				
				let calEvent = CalendarEvent(title: event.title, startDate: startDate, endDate: endDate)
				
				let indexPath = IndexPath(item: distanceFromStartComponent.day!, section: distanceFromStartComponent.month!)
				
				if var eventsList: [CalendarEvent] = eventsByIndexPath[indexPath] { // If there is already a list at this path (list being array of calendar event(s)
					eventsList.append(calEvent) //Then just tack it on to the end!
				} else {
					eventsByIndexPath[indexPath] = [calEvent] // Otherwise start it with this being the first!
				}
			}
			
			self.calendarView.reloadData()
			
		}
	}
	
	// I don't like that the view decides how large the header is either I'll move this to a controller or I'll let the header decide it's own height and the View here can just ask it what it is, if that's allowed... Maybe because View is just that - a view - it'll use a delegte to ask the controller and controller will go get it and get back to the view
	lazy var headerView: CalendarHeaderView = {
		let headerViewThatDisplaysMonthInfo = CalendarHeaderView(frame: CGRect.zero)
		return headerViewThatDisplaysMonthInfo
	}()

	lazy var calendarView: UICollectionView = {

		let layout = CalendarFlowLayout()
		layout.scrollDirection = self.direction
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		
		let collectionViewWithDates = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		collectionViewWithDates.dataSource = self
		collectionViewWithDates.delegate = self
		collectionViewWithDates.isPagingEnabled = true
		collectionViewWithDates.backgroundColor = UIColor.clear
		collectionViewWithDates.showsHorizontalScrollIndicator = false
		collectionViewWithDates.showsVerticalScrollIndicator = false
		collectionViewWithDates.allowsMultipleSelection = true
		
		return collectionViewWithDates
	}()

	override var frame: CGRect {
		didSet {
			
			let heightOfDateSection = frame.size.height - headerDefaultHeight
			let widthOfDateSection = frame.size.width
			
			self.headerView.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: headerDefaultHeight)
			self.calendarView.frame = CGRect(x: 0.0, y: headerDefaultHeight, width: widthOfDateSection, height: heightOfDateSection)
			
			let scrollableDateArea = self.calendarView.collectionViewLayout as! UICollectionViewFlowLayout
			scrollableDateArea.itemSize = CGSize(width: widthOfDateSection / CGFloat(numberOfDaysInWeek), height: heightOfDateSection / CGFloat(maximumNumberOfRows))
			
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 200.0))
		self.createSubviews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.createSubviews()
	}
	
	//Mark: Setup the subviews, headerView and calendarView

	fileprivate func createSubviews () {
		self.clipsToBounds = true
		
		//Register Class
		self.calendarView.register(CalendarDayCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
		
		self.addSubview(self.headerView)
		self.addSubview(self.calendarView)
	}
	
	//Mark: UICollectionViewDataSource
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {

		guard let startDate = self.collectionDataSource?.startDate(), let endDate = self.collectionDataSource?.endDate() else {
			return 0
		}
	
	
		self.startDateCache = startDate as NSDate
		self.endDateCache = endDate as NSDate
		
		if (self.gregorian as NSCalendar).compare(startDate as Date, to: endDate as Date, toUnitGranularity: .nanosecond) != ComparisonResult.orderedAscending {
			return 0
		}
		
		var firstDayOfStartMonth = (self.gregorian as NSCalendar).components([.era, .year, .month], from: startDateCache as Date)
		firstDayOfStartMonth.day = 1
		
		guard let dateFromDayOneComponents = self.gregorian.date(from: firstDayOfStartMonth) else {
			return 0
		}
		
		self.startOfMonthCache = dateFromDayOneComponents as NSDate
		
		let today = Date() // Where are you having your value be set? How can I compare against you if I haven't given you a date!!
		
		if startOfMonthCache.compare(today) == ComparisonResult.orderedAscending && endDateCache.compare(today) == ComparisonResult.orderedAscending {
			
			let differenceFromTodayComponents = (self.gregorian as NSCalendar).components([NSCalendar.Unit.month, NSCalendar.Unit.day], from: startOfMonthCache as Date, to: today, options: NSCalendar.Options())
			
			self.todayIndexPath = IndexPath(item: differenceFromTodayComponents.day!, section: differenceFromTodayComponents.month!) as NSIndexPath
		}
		
		let differenceComponents = (self.gregorian as NSCalendar).components(NSCalendar.Unit.month, from: startDateCache as Date, to: endDateCache as Date, options: NSCalendar.Options())

		return differenceComponents.month! + 1 // Because this is a difference you need to include one extra to have all the sections you need, eg difference between Feb 1 and Feb 10 is 0 months but you still need to indicate there is a month!
	}
	
	var monthInfo: [Int:[Int]] = [Int:[Int]]()
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		var monthOffsetComponents = DateComponents()
		
		// offset by the number of months
		monthOffsetComponents.month = section;
		
		guard let correctMonthForSectionDate = (self.gregorian as NSCalendar).date(byAdding: monthOffsetComponents, to: startOfMonthCache as Date, options: NSCalendar.Options()) else {
			return 0
		}
		
		let numberOfDaysInMonth = (self.gregorian as NSCalendar).range(of: .day, in: .month, for: correctMonthForSectionDate).length
		
		var firstWeekdayOfMonthIndex = (self.gregorian as NSCalendar).component(NSCalendar.Unit.weekday, from: correctMonthForSectionDate)
		firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1 // firstWeekdayOfMonthIndex should be 0-Indexed
		firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7 // push it modularly so that we take it back one day so that the first day is Monday instead of Sunday which is the default
		
		monthInfo[section] = [firstWeekdayOfMonthIndex, numberOfDaysInMonth]
		
		return numberOfDaysInWeek * maximumNumberOfRows // 7 x 6 = 42
		
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let dayCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CalendarDayCell
		
		let currentMonthInfo: [Int] = monthInfo[(indexPath as NSIndexPath).section]!
		
		let fDayIndex = currentMonthInfo[firstDayIndex]
		let numberOfDays = currentMonthInfo[numberOfDaysIndex]
		
		let fromStartOfMonthIndexPath = IndexPath(item: (indexPath as NSIndexPath).item - fDayIndex, section: (indexPath as NSIndexPath).section)

		if (indexPath as NSIndexPath).item >= fDayIndex && (indexPath as NSIndexPath).item < fDayIndex + numberOfDays {
			dayCell.textLabel.text = String((fromStartOfMonthIndexPath as NSIndexPath).item + 1)
			dayCell.isHidden = false
		} else {
			dayCell.textLabel.text = ""
			dayCell.isHidden = true
		}

		dayCell.isSelected = selectedIndexPaths.contains(indexPath)

		if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).item == 0 {
			self.scrollViewDidEndDecelerating(collectionView)
		}

		if let index = todayIndexPath {
			dayCell.isToday = ((index as NSIndexPath).section == (indexPath as NSIndexPath).section) && ((index as NSIndexPath).item + firstDayIndex == (indexPath as NSIndexPath).item)
		} else {
			dayCell.eventsCount = 0
		}
		return dayCell
	}


	// MARK: UIScrollViewDelegate
	
	func calculateDateBasedOnScrollViewPostiton() -> Date? {
		
		let calendarViewBounds = self.calendarView.bounds
		var page: Int = 0
		
		switch self.direction {
			
		case .horizontal:
			page = Int(floor(self.calendarView.contentOffset.x / calendarViewBounds.size.width))
			
		case .vertical:
			page = Int(floor(self.calendarView.contentOffset.y / calendarViewBounds.size.height))
		}
		
		page = page > 0 ? page : 0
		
		var monthsOffsetComponents = DateComponents() // Give components next
		monthsOffsetComponents.month = page
		
		guard let yearDate = (self.gregorian as NSCalendar).date(byAdding: monthsOffsetComponents, to: self.startOfMonthCache as Date, options: NSCalendar.Options()) else { return nil }
		
		let month = (self.gregorian as NSCalendar).component(NSCalendar.Unit.month, from: yearDate) // Get month value
		
		let monthName = DateFormatter().monthSymbols[(month-1) % 12] // Returns month name but must consider that it is 0 indexed
		
		let year = (self.gregorian as NSCalendar).component(NSCalendar.Unit.year, from: yearDate)
		
		self.headerView.monthLabel.text = monthName + "" + String(year)
		
		self.displayDate = yearDate
		
		return yearDate
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

		let yearDate = self.calculateDateBasedOnScrollViewPostiton()
		
		if let date = yearDate, let delegate = self.prayerDelegate {
			delegate.calendar(self, didScrollToMonth: date as Date)
		}
	}

	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		let yearDate = self.calculateDateBasedOnScrollViewPostiton()
		
		if let date = yearDate, let delegate = self.prayerDelegate {
			delegate.calendar(self, didScrollToMonth: date as Date)
		}
	}
	
	// MARK: UICollectionViewDelegate
	
	fileprivate var dateBeingSelectedByUser: Date?
	
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		
		let currentMonthInfo: [Int] = monthInfo[(indexPath as NSIndexPath).section]!
		let firstDayInMonth = currentMonthInfo[firstDayIndex]
		
		var offsetComponents = DateComponents() // Give components next
		offsetComponents.month = (indexPath as NSIndexPath).section
		offsetComponents.day = (indexPath as NSIndexPath).item - firstDayInMonth
		
		if let dateUserSelected = (self.gregorian as NSCalendar).date(byAdding: offsetComponents, to: startOfMonthCache as Date, options: NSCalendar.Options()) {
			
			self.dateBeingSelectedByUser = dateUserSelected
			
			// The Optional protocol method (the delegate can "object") [not sure what this means...]
			if let canSelectFromDelegate = prayerDelegate?.calendar?(self, canSelectDate: dateUserSelected as Date) {
				return canSelectFromDelegate
			}
			
			return true // Horray! It can select any date by default!
		}
		
		return false // if date is out of scope
	}
	
	func selectDate(_ date: Date) {
		
		guard let indexPath = self.indexPathForDate(date) else { return }
		
		guard self.calendarView.indexPathsForSelectedItems?.contains(indexPath) == false else { return }
		
		self.calendarView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
		
		selectedIndexPaths.append(indexPath)
		selectedDates.append(date as NSDate)
	}
	func deselectDate(_ date: Date) {

		guard let indexPath = self.indexPathForDate(date) else { return }
		
		guard self.calendarView.indexPathsForSelectedItems?.contains(indexPath) == false else { return }
		
		self.calendarView.deselectItem(at: indexPath, animated: false)
		
		guard let index = self.selectedIndexPaths.index(of: indexPath) else { return }
		
		selectedIndexPaths.remove(at: index)
		selectedDates.remove(at: index)
	}
	
	func indexPathForDate(_ date: Date) -> IndexPath? {
		
		let distanceFromStartComponent = (self.gregorian as NSCalendar).components([.month, .day], from: startOfMonthCache as Date, to: date, options: NSCalendar.Options())
		
		guard let currentMonthInfo: [Int] = monthInfo[distanceFromStartComponent.month!] else { return nil }
		
		let item = distanceFromStartComponent.day! + currentMonthInfo[firstDayIndex]
		let indexPath = IndexPath(item: item, section: distanceFromStartComponent.month!)
		
		return indexPath
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let dateBeingSelectedByUser = dateBeingSelectedByUser else { return }
		
		let currentMonthInfo: [Int] = monthInfo[(indexPath as NSIndexPath).section]!
		
		let fromStartOfMonthIndexPath = IndexPath(item: (indexPath as NSIndexPath).item - currentMonthInfo[firstDayIndex], section: (indexPath as NSIndexPath).section)
		
		var eventsArray: [CalendarEvent] = [CalendarEvent]()
		
		if let eventsForDay = eventsByIndexPath[fromStartOfMonthIndexPath] {
			eventsArray = eventsForDay
		}
		
		prayerDelegate?.calendar(self, didSelectDate: dateBeingSelectedByUser as Date, withEvents: eventsArray)
		
		selectedIndexPaths.append(indexPath)
		selectedDates.append(dateBeingSelectedByUser as NSDate)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		
		guard let dateBeingSelectedByUser = dateBeingSelectedByUser else { return }
		
		guard let index = selectedIndexPaths.index(of: indexPath) else { return }
		
		self.prayerDelegate?.calendar?(self, didDeselectDate: dateBeingSelectedByUser as Date)
		
		selectedIndexPaths.remove(at: index)
		selectedDates.remove(at: index)
	}
	
	func reloadData() {
		self.calendarView.reloadData()
	}
	
	func setDisplayDate(_ date: Date, animated: Bool) {
		
		if let dispDate = self.displayDate {
			
			// Don't complete the action if we are attempting to set the same date
			guard date.compare(dispDate) != ComparisonResult.orderedSame else { return }
			
			guard date.compare(startDateCache as Date) != ComparisonResult.orderedAscending || date.compare(endDateCache as Date) != ComparisonResult.orderedDescending else { return }
			
			let difference = (self.gregorian as NSCalendar).components([NSCalendar.Unit.month], from: startOfMonthCache as Date, to: date, options: NSCalendar.Options())
			let distance: CGFloat = CGFloat(difference.month!) * self.calendarView.frame.size.width
			self.calendarView.setContentOffset(CGPoint(x: distance, y: 0.0), animated: animated)
			_ = self.calculateDateBasedOnScrollViewPostiton()
		}
	}
}
