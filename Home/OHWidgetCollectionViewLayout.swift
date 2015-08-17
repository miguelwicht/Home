//  OHWidgetCollectionViewLayout.swift
//  OpenhabApi
//
//  Created by Miguel dos Santos Vaz Dias Wicht on 28/04/15.
//  Copyright (c) 2015 Miguel dos Santos Vaz Dias Wicht. All rights reserved.
//

import UIKit

class OHWidgetCollectionViewLayout: UICollectionViewFlowLayout {
    
    var rows: Int = 2
    var columns: Int = 3
    var columnOffsetsForCells: [CGPoint]?
    
    override func prepareLayout() {
        super.prepareLayout()
        
        self.sectionInset = UIEdgeInsetsMake(0, 5, 10, 5)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        calculateColumnOffsets()
    }
    
    func calculateColumnOffsets() {
        columnOffsetsForCells = [CGPoint]()
        columns = Int(CGFloat(collectionView!.bounds.width - minimumInteritemSpacing) / (itemSize.width + minimumInteritemSpacing))
        rows = Int(CGFloat(collectionView!.bounds.height - minimumLineSpacing) / itemSize.height)
        
        // fix so that we get at least 1 row for the calculations as Int() will round up
        rows = rows == 0 ? 1 : rows
        
        // get space that is not occupied by items
        let width = collectionView!.bounds.width
        var spacing: CGFloat = width - CGFloat(columns) * itemSize.width
        
        // divide that space evenly
        let calculatedSpacing = spacing / CGFloat(columns + 1)
        spacing = calculatedSpacing >= minimumInteritemSpacing ? calculatedSpacing : minimumInteritemSpacing
        
        var verticalSpacing: CGFloat = collectionView!.bounds.height - CGFloat(rows) * itemSize.height
        let calculatedVerticalSpacing = verticalSpacing / CGFloat(rows)
        
        verticalSpacing = calculatedVerticalSpacing >= minimumLineSpacing ? calculatedVerticalSpacing : minimumLineSpacing
        
        for var row = 0; row < rows; row++ {
            var offsetPoint: CGPoint = CGPointZero
            
            for var col = 0; col < columns; col++ {
                offsetPoint.x = (col == 0) ? spacing : CGFloat(col + 1) * spacing
                offsetPoint.y = (row == 0) ? 0 : CGFloat(row + 1) * verticalSpacing - verticalSpacing
                columnOffsetsForCells = columnOffsetsForCells == nil ? [CGPoint]() : columnOffsetsForCells
                columnOffsetsForCells!.append(offsetPoint)
            }
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        let numberOfItems = CGFloat(collectionView!.numberOfItemsInSection(0))
        let itemsPerPage = rows > 0 ? CGFloat(rows * columns) : CGFloat(columns)
        let pageCount = ceil(CGFloat(numberOfItems / itemsPerPage))
        
        let width = CGFloat(collectionView!.bounds.width * pageCount)
        let height: CGFloat = collectionView!.bounds.height
        
        return CGSizeMake(width, height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elementsInRect: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        let numberOfItems = self.collectionView!.numberOfItemsInSection(0)
        
        for var i = 0; i < numberOfItems; i++ {
            let itemsPerPage = self.rows > 0 ? CGFloat(self.rows * self.columns) : CGFloat(self.columns)
            let pageIndex = Int(i / Int(itemsPerPage))
            let offset = pageIndex * self.rows * self.columns
            let index = i - offset
            
            let offsetPoint = CGPointMake(self.columnOffsetsForCells![index].x, self.columnOffsetsForCells![index].y)
            var cellFrame: CGRect = CGRectMake(CGFloat(pageIndex) * self.collectionView!.bounds.width + CGFloat(offsetPoint.x), offsetPoint.y, self.itemSize.width, self.itemSize.height)
            let mod = index % self.columns
            cellFrame.origin.x = cellFrame.origin.x + CGFloat(mod) * self.itemSize.width
            
            let currentRow = Int(index / self.columns)
            cellFrame.origin.y = cellFrame.origin.y + CGFloat(currentRow) * self.itemSize.height
        
            // only calculate attributes if cell is visible
            if (CGRectIntersectsRect(cellFrame, rect)) {
                //create the attributes object
                let indexPath = NSIndexPath(forRow: i, inSection: Int(0))
                let attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                
                //set the frame for this attributes object
                attr.frame = cellFrame;
                elementsInRect.append(attr)
            }
        }
        
        return elementsInRect
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attr = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        return attr
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)
    }
}
