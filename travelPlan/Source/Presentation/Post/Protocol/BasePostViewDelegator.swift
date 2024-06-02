//
//  BasePostViewDelegator.swift
//  travelPlan
//
//  Created by 양승현 on 5/28/24.
//

import UIKit

/// BasePostViewDelegate를 처리하는 protocol입니다.
protocol BasePostViewDelegator: BasePostViewDelegate { }

/// BasePostCell일 때 postViewDelegate의 델리게이트를 호출합니다.
/// PostViewCell의 경우 섬네일에 따라 1...5개까지 객체들이 존재합니다.
/// 섬네일에 따라서 달라지는데, 하나의 cell에서 분기처리를 할 경우 지속적으로 스크롤할 경우 성능이 좋지 않아 개별적으로 재사용큐에서 즉시 각각 꺼내오도록 구현했습니다.
/// 그러기에 PostView의 델리게이트를 처리하고, PostViewDelegate로 변환해야하는 로직이 중복될 수있지만, Delegator에서 담당하고록 설계했습니다.
extension BasePostViewDelegator where Self: UICollectionViewCell, Self: BasePostCell {
  func didTapComment() {
    postViewDelegate?.didTapComment(self)
  }
  
  func didTapShare() {
    postViewDelegate?.didTapShare(self)
  }
  
  func didTapOption() {
    postViewDelegate?.didTapOption(self)
  }
  
  func didTapHeart() {
    postViewDelegate?.didTapHeart(self)
  }
}
