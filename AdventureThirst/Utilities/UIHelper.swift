//
//  UIHelper.swift
//  AdventureThirst
//
//  Created by Evgeni Novik on 16.12.2024.
//

import UIKit

struct UIHelper {
    
    static func createTwoColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 20
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 100)
        
        return flowLayout
    }
    
    static func createTwoSquareColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 10
        let minimumItemSpacing: CGFloat = 5
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 280)
        
        return flowLayout
    }
    
    static func createOneColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 10
        let availableWidth = width - (padding * 2)
        let itemWidth = availableWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 510)
        
        return flowLayout
    }
    
    static func createHorizontalLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 20
        let availableWidth = width - (padding * 2)
        let itemWidth = availableWidth / 5
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 100)
        
        return flowLayout
    }
    
    static func createOneRectangleColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 5
        let itemWidth = width - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 160)
        
        return flowLayout
    }
    
    static func createOneRectangleColumnLayoutForBusiness(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 5
        let itemWidth = width - (padding * 2)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 140)
        
        return flowLayout
    }
}
