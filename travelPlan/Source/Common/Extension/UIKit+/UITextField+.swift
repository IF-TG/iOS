//
//  UITextField+.swift
//  travelPlan
//
//  Created by SeokHyun on 9/24/24.
//

import UIKit

extension UITextField {
  /// 해당 메소드를 호출하면 키보드가 등장할 때 [UIKeyboardTaskQueue lockWhenReadyForMainThread] timeout waiting for task on queue가 호출되는 문제점을 해결합니다.
  ///
  /// 수정제안 View가 뜨는 것을 방지합니다.
  func removeAmendmentProposal() {
    spellCheckingType = .no
    autocorrectionType = .no
  }
}
