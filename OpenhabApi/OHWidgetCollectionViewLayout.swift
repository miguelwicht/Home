//
//  OHWidgetCollectionViewLayout.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 28/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHWidgetCollectionViewLayout: UICollectionViewLayout {
    
    var rows: Int = 2
    var itemsPerRow = 3
    var itemSize = CGSizeMake(60, 100)
    
    override func prepareLayout() {
        super.prepareLayout()
    }
    
    override func collectionViewContentSize() -> CGSize {
        
        let width: CGFloat = CGFloat(self.collectionView!.numberOfSections()) * self.collectionView!.frame.width
        let height: CGFloat = self.collectionView!.frame.height
        
        return CGSizeMake(width, height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var elementsInRect: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        
        for var i = 0; i < self.collectionView!.numberOfSections(); i++ {
            for var j = 0; j < self.collectionView?.numberOfItemsInSection(i); j++ {
                
                var row = j < itemsPerRow ? 0 : 1
                
                var itemOffset = row == 0 ? j : j - itemsPerRow
                
                var originX: CGFloat = CGFloat(i) * self.collectionView!.frame.width + CGFloat(itemOffset) * self.itemSize.width
                var originY: CGFloat = CGFloat(row) * itemSize.height
                
                var cellFrame: CGRect = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height)
                
                var spacing: CGFloat = self.collectionView!.frame.width - CGFloat(itemsPerRow) * itemSize.width
                spacing = spacing / CGFloat(itemsPerRow - 1)
                
                
                if (itemOffset > 0 && itemOffset < itemsPerRow)
                {
                    cellFrame.origin.x = cellFrame.origin.x + CGFloat(itemOffset) * spacing
                }
                
                // only calculate attributes if cell is visible
                if(CGRectIntersectsRect(cellFrame, rect))
                {
                    //create the attributes object
//                    var indexPath: NSIndexPath = NSIndexPath(indexPathForRow:j inSection:i)
                    var indexPath = NSIndexPath(forRow: j, inSection: i)
                    var attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                    
                    //set the frame for this attributes object
                    attr.frame = cellFrame;
                    elementsInRect.append(attr)
                }
            }
        }
        
        return elementsInRect
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var row = indexPath.row < itemsPerRow ? 1 : 2
        
        var originX: CGFloat = CGFloat(indexPath.section) * self.collectionView!.frame.width + CGFloat(indexPath.row) * self.itemSize.width
        var originY: CGFloat = CGFloat(row) * itemSize.height + 10
        
        var cellFrame: CGRect = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height)
        
        attr.frame = cellFrame
        
        return attr
        
    }
}
