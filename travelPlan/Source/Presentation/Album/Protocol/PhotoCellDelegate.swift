//
//  PhotoCellDelegate.swift
//  travelPlan
//
//  Created by SeokHyun on 1/9/24.
//

import UIKit.UICollectionViewCell

protocol PhotoCellDelegate: AnyObject {
  func didTapCell(_ cell: UICollectionViewCell, quadrant: PhotoCellQuadrant)
}
