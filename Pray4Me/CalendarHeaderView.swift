//
//  CalendarHeaderView.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-19.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class CalendarHeaderView: UIView {

	lazy var monthLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = NSTextAlignment.center
		label.font = UIFont(name: "Helvetica", size: 20.0)
		label.textColor = UIColor.gray

		self.addSubview(label)

		return label
	}()

	lazy var dayLabelContainerView: UIView = {

		let theView = UIView()
		let formatter: DateFormatter = DateFormatter()
		for index in 1...7 {
			let day: NSString = formatter.weekdaySymbols[index % 7] as NSString

			let weekdayLabel = UILabel()

			weekdayLabel.font = UIFont(name: "Helvetica", size: 14.0)

			weekdayLabel.text = day.substring(to: 2).uppercased()
			weekdayLabel.textColor = UIColor.gray
			weekdayLabel.textAlignment = NSTextAlignment.center

			theView.addSubview(weekdayLabel)
		}

		self.addSubview(theView)

		return theView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		var frame = self.bounds
		frame.origin.y += 5.0
		frame.size.height = 40.0
		
		self.monthLabel.frame = frame
		
		var labelFrame = CGRect(x: 0.0, y: self.bounds.size.height / 2.0, width: self.bounds.size.width / 7.0 , height: self.bounds.size.height / 2.0)
		
		for label in self.dayLabelContainerView.subviews {
			label.frame = labelFrame
			labelFrame.origin.x += labelFrame.size.width
		}
	}

}
