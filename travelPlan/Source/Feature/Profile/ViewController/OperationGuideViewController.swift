//
//  OperationGuideViewController.swift
//  travelPlan
//
//  Created by 양승현 on 11/29/23.
//

import UIKit

final class OperationGuideViewController: BaseSettingViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let highlightInfo = HighlightFontInfo(
      fontType: .semiBold_600(fontSize: 15),
      lineHeight: 23,
      text: yeogaUsageHighlightText,
      additionalAttributes: [.foregroundColor: UIColor.yg.primary.cgColor])
    
    _=BaseLabel(
      fontType: .semiBold_600(fontSize: 15),
      lineHeight: 23
    ).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.text = yeogaUsageText
      $0.setHighlight(with: highlightInfo)
      $0.numberOfLines = 0
      view.addSubview($0)
      NSLayoutConstraint.activate([
        $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        $0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)])
    }
  }
}

// MARK: - Private Helpers
extension OperationGuideViewController {
  fileprivate var yeogaUsageText: String {
    """
    안녕하세요.
    여행을 가다, 여가입니다.
    
    ‘여가’는 내가 세운 여행 계획을 공유하고 여행자의 후기를 편하게 찾아보는 소셜 미디어 플랫폼입니다. 유저 간의 여행 리뷰 포스트를 통한 경험 나눔을 통해 새로운 여행을 다짐하고, 추억을 기록할 수 있습니다.
    
    단순히 여행을 갔다 오는 것 만이 아닌, ‘동안’의 경험을 사진으로 남기고 더욱 생생하게 남기기 위해 기록하는 습관을 가지는 건 어떨까요? :)
    
    
    여행자로서 미처 생각하지 못했던 아쉬운 경험, 불편했던 점, 행복했던 소중한 나만의 경험을 다른 이들과 이야기를 통해 나누어보세요.
    """
  }
  
  fileprivate var yeogaUsageHighlightText: String {
    """
    ‘여가’는 내가 세운 여행 계획을 공유하고 여행자의 후기를 편하게 찾아보는 소셜 미디어 플랫폼입니다. 유저 간의 여행 리뷰 포스트를 통한 경험 나눔을 통해 새로운 여행을 다짐하고, 추억을 기록할 수 있습니다.
    """
  }
}
