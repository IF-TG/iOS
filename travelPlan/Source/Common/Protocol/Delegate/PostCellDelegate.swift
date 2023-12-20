//
//  PostCellDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 12/20/23.
//

import UIKit

protocol PostCellDelegate: AnyObject {
  // TODO: - 추후 프로필 화면으로 이동하는 함수 추가해야함
  func didTapHeart(in cell: UICollectionViewCell)
  func didTapComment(in cell: UICollectionViewCell)
  func didTapShare(in cell: UICollectionViewCell)
  func didTapOption(in cell: UICollectionViewCell)
}
