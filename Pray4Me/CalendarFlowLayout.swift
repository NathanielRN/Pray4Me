//
//  CalendarFlowLayout.swift
//  Pray4Me
//
//  Created by Nathaniel Ruiz on 2017-03-18.
//  Copyright © 2017 Nathaniel Ruiz. All rights reserved.
//

import UIKit

class CalendarFlowLayout: UICollectionViewFlowLayout {
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		return super.layoutAttributesForElements(in: rect)?.map {
			attributes in
			let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
			self.applyLayoutAttributes(attributesCopy)
			return attributesCopy
		}
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		if let attributes = super.layoutAttributesForItem(at: indexPath) {
			let attributesCopy = attributes.copy() as! UICollectionViewLayoutAttributes
			self.applyLayoutAttributes(attributesCopy)
			return attributesCopy
		}
		return nil
	}
	
	func applyLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) {
		
		if attributes.representedElementKind != nil {
			return
		}
		
		if let collectionView = self.collectionView {
			
			let stride = (self.scrollDirection == .horizontal) ? collectionView.frame.size.width : collectionView.frame.size.height
			
			let offset = CGFloat((attributes.indexPath as NSIndexPath).section) * stride
			
			var xCellOffset: CGFloat = CGFloat((attributes.indexPath as NSIndexPath).item % 7) * self.itemSize.width
			
			var yCellOffset: CGFloat = CGFloat((attributes.indexPath as NSIndexPath).item / 7) * self.itemSize.height
			
			if(self.scrollDirection == .horizontal) {
				xCellOffset += offset
			} else {
				yCellOffset += offset
			}
			
			attributes.frame = CGRect(x: xCellOffset, y: yCellOffset, width: self.itemSize.width, height: self.itemSize.height)
		}
	}
}
