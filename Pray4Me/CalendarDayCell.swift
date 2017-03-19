//
//  CalendarDayCell.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-19.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

let cellColorDefault = UIColor(white: 0.0, alpha: 0.1)
let cellColorToday = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.3)
let borderColor = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 64.0/255.0, alpha: 0.8)

class CalendarDayCell: UICollectionViewCell {
	
	lazy var dotsView: UIView = {
		
		let frame = CGRect(x: 8.0, y: self.frame.width - 10.0 - 4.0, width: self.frame.size.width - 16.0, height: 8.0)
		let dv = UIView(frame: frame)
		
		return dv
	}()

	var eventsCount = 0 {
		didSet {
			for subView in self.dotsView.subviews {
				subView.removeFromSuperview()
			}
			
			let stride = self.dotsView.frame.size.width / CGFloat(eventsCount + 1)
			let viewHeight = self.dotsView.frame.size.height
			let halfViewHeight = viewHeight / 2.0
			
			for _ in 0..<eventsCount {
				let frame = CGRect(x: (stride + 1.0) - halfViewHeight, y: 0.0, width: viewHeight, height: viewHeight)
				let circle = UIView(frame: frame)
				circle.layer.cornerRadius = halfViewHeight
				circle.backgroundColor = borderColor
				self.dotsView.addSubview(circle)
			}
		}
	}
	
	var isToday: Bool = false {
		didSet {
			if isToday == true {
				self.someBackgroundView.backgroundColor = cellColorToday
			} else {
				self.someBackgroundView.backgroundColor = cellColorDefault
			}
		}
	}
	
	override var isSelected: Bool {
		didSet {
			
			if isSelected == true {
				self.someBackgroundView.layer.borderWidth = 2.0
			} else {
				self.someBackgroundView.layer.borderWidth = 0.0
			}
		}
	}
	
	lazy var someBackgroundView: UIView = {
		
		var viewFrame = self.frame.insetBy(dx: 3.0, dy: 3.0)
		
		let view = UIView(frame: viewFrame)
		
		view.layer.cornerRadius = 4.0
		
		view.layer.borderColor = borderColor.cgColor
		view.layer.borderWidth = 0.0
		
		view.center = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 5.0)
		
		view.backgroundColor = cellColorDefault
		
		return view
	}()
	
	lazy var textLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = NSTextAlignment.center
		label.textColor = UIColor.darkGray
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.addSubview(self.someBackgroundView)
		
		self.textLabel.frame = self.bounds
		self.addSubview(self.textLabel)
		
		self.addSubview(dotsView)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
