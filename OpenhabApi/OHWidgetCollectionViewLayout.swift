//
//  OHWidgetCollectionViewLayout.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 28/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHWidgetCollectionViewLayout: UICollectionViewFlowLayout {
    
//    var rows: Int = 2
//    var itemsPerRow = 3
////    var itemSize = CGSizeMake(60, 100)
//    var columnOffsetsForCells: [CGFloat] = [CGFloat]()
    
    var rows: Int = 2
    var columns: Int = 3
    var columnOffsetsForCells: [CGPoint] = [CGPoint]()
    
    override func prepareLayout() {
        super.prepareLayout()
        
        self.itemSize = CGSizeMake(80, 100)
        self.sectionInset = UIEdgeInsetsMake(30, 5, 10, 5)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        self.minimumInteritemSpacing = 20
//        self.minimumLineSpacing = 10
        
        calculateColumnOffsets()
    }
    
    func calculateColumnOffsets()
    {
        self.columnOffsetsForCells = [CGPoint]()
        
        self.columns = Int(CGFloat(self.collectionView!.bounds.width - self.minimumInteritemSpacing) / self.itemSize.width)
        self.rows = Int(CGFloat(self.collectionView!.bounds.height - self.minimumLineSpacing) / self.itemSize.height)
        
        var spacing: CGFloat = self.collectionView!.bounds.width - CGFloat(columns) * itemSize.width
        //spacing = spacing / CGFloat(columns - 1)
        spacing = spacing / CGFloat(columns + 1)
        
        var verticalSpacing: CGFloat = self.collectionView!.bounds.height - CGFloat(rows) * itemSize.height
        verticalSpacing = verticalSpacing / CGFloat(rows + 1)
        
        for var row = 0; row < self.rows; row++ {
            var offsetPoint: CGPoint = CGPointZero
            
            for var col = 0; col < columns; col++ {
                
                offsetPoint.x = (col == 0) ? CGFloat(col + 1) * spacing : CGFloat(col + 1) * spacing
                offsetPoint.y = (row == 0) ? CGFloat(row + 1) * verticalSpacing : CGFloat(row + 1) * verticalSpacing
                
                columnOffsetsForCells.append(offsetPoint)
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize
    {
        var numberOfItems = CGFloat(self.collectionView!.numberOfItemsInSection(0))
        var itemsPerPage = CGFloat(self.rows * self.columns)
        
        var pageCount = ceil(CGFloat(numberOfItems / itemsPerPage))
        
        var width = CGFloat(self.collectionView!.bounds.width * pageCount)
        let height: CGFloat = self.collectionView!.bounds.height
        
        return CGSizeMake(width, height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
//        return super.layoutAttributesForElementsInRect(rect)
        
//        return attributesForElementsInRectWithSections(rect)
        
        
        var elementsInRect: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        
        var numberOfItems = self.collectionView!.numberOfItemsInSection(0)
        
        for var i = 0; i < numberOfItems; i++ {
            
            var pageIndex = Int(i / (self.rows * self.columns))
            var offset = pageIndex * self.rows * self.columns
            var index = i - offset
//            var index = self.collectionView!.numberOfItemsInSection(0) - 1 - i
            
            var offsetPoint = CGPointMake(self.columnOffsetsForCells[index].x, self.columnOffsetsForCells[index].y)
            
            var cellFrame: CGRect = CGRectMake(CGFloat(pageIndex) * self.collectionView!.bounds.width + CGFloat(offsetPoint.x), offsetPoint.y, self.itemSize.width, self.itemSize.height)
            
            var mod = index % self.columns
            
            cellFrame.origin.x = cellFrame.origin.x + CGFloat(mod) * self.itemSize.width
            
//            if (index < self.columns) {
//               cellFrame.origin.x = cellFrame.origin.x + CGFloat(index) * self.itemSize.width
//            }
//            else {
//                cellFrame.origin.x = cellFrame.origin.x + CGFloat(index - self.columns) * self.itemSize.width
//            }
            
            var currentRow = Int(index / self.columns)
            
            cellFrame.origin.y = cellFrame.origin.y + CGFloat(currentRow) * self.itemSize.height
            
//            cellFrame.origin.x = cellFrame.origin.x + CGFloat(index) * self.itemSize.width
        
            // only calculate attributes if cell is visible
            if(CGRectIntersectsRect(cellFrame, rect))
            {
                //create the attributes object
                //                    var indexPath: NSIndexPath = NSIndexPath(indexPathForRow:j inSection:i)
                var indexPath = NSIndexPath(forRow: i, inSection: Int(0))
                var attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                //set the frame for this attributes object
                attr.frame = cellFrame;
                elementsInRect.append(attr)
            }
        }
        
        return elementsInRect
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
//        var row = indexPath.row < itemsPerRow ? 1 : 2
        
//        var originX: CGFloat = CGFloat(indexPath.section) * self.collectionView!.frame.width + CGFloat(indexPath.row) * self.itemSize.width
//        var originY: CGFloat = CGFloat(row) * itemSize.height + 10
        
//        var cellFrame: CGRect = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height)
        
//        attr.frame = cellFrame
        
        return attr
        
    }
    
    
}

extension OHWidgetCollectionViewLayout {
//    func attributesForElementsInRectWithSections(rect: CGRect) -> [AnyObject]? {
//        var elementsInRect: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
//        
//        for var i = 0; i < self.collectionView!.numberOfSections(); i++ {
//            
//            for var j = 0; j < self.collectionView?.numberOfItemsInSection(i); j++ {
//                
//                var row = j < itemsPerRow ? 0 : 1
//                
//                var itemOffset = row == 0 ? j : j - itemsPerRow
//                var maxWidth = self.collectionView!.frame.width
//                var offsetX = 1
//                
//                var originX: CGFloat = self.sectionInset.left + CGFloat(i) * self.collectionView!.bounds.width + CGFloat(itemOffset) * self.itemSize.width
//                var originY: CGFloat = self.sectionInset.top + CGFloat(row) * itemSize.height
//                
//                var cellFrame: CGRect = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height)
//                
//                //                var spacing: CGFloat = self.collectionView!.frame.width - CGFloat(itemsPerRow) * itemSize.width - self.sectionInset.left - self.sectionInset.right
//                //                spacing = spacing / CGFloat(itemsPerRow - 1)
//                //
//                //
//                //                if (itemOffset > 0 && itemOffset < itemsPerRow)
//                //                {
//                //                    cellFrame.origin.x = cellFrame.origin.x + CGFloat(itemOffset) * spacing
//                //                }
//                
//                cellFrame.origin.x = cellFrame.origin.x + columnOffsetsForCells[itemOffset]
//                
//                // only calculate attributes if cell is visible
//                if(CGRectIntersectsRect(cellFrame, rect))
//                {
//                    //create the attributes object
//                    //                    var indexPath: NSIndexPath = NSIndexPath(indexPathForRow:j inSection:i)
//                    var indexPath = NSIndexPath(forRow: j, inSection: i)
//                    var attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//                    
//                    //set the frame for this attributes object
//                    attr.frame = cellFrame;
//                    elementsInRect.append(attr)
//                }
//            }
//        }
//        
//        return elementsInRect
//    }
}
