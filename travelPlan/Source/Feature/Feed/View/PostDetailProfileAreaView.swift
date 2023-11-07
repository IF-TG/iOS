//
//  PostDetailProfileAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

/// 임시
struct PostDetailProfileAreaInfo {
  let userName: String
  let userId: String
  
  /// 임시
  let userThumbnailPath: String
  let travelDuration: String
  let travelCalendarDateRange: String
  let uploadedDescription: String
}

final class PostDetailProfileAreaView: BaseProfileAreaView {
  // MARK: - Properties
  private let userNameLabel = BaseLabel(fontType: .medium_500(fontSize: 15)).set {
    $0.textColor = .yg.gray7
    $0.numberOfLines = 1
  }
  
  private let travelDurationLabel = BaseLabel(fontType: .medium_500(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray5
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }
  
  private let travelCalendarDateRangeLabel = BaseLabel(fontType: .medium_500(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray5
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }
  
  private let durationDivider = UILabel().set {
    $0.backgroundColor = .yg.gray5
    $0.heightAnchor.constraint(equalToConstant: 13).isActive = true
    $0.widthAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  private let uploadedDescriptionLabel = BaseLabel(fontType: .regular_400(fontSize: 12), lineHeight: 14.32).set {
    $0.textColor = .yg.gray5
    $0.numberOfLines = 1
  }
  
  private let travelDurationStackView: UIStackView
  
  private let contentStackView: UIStackView
  
  // MARK: - Lifecycle
  init(frame: CGRect) {
    travelDurationStackView = UIStackView(
      arrangedSubviews: [travelDurationLabel, durationDivider, travelCalendarDateRangeLabel]
    ).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.spacing = 10
      $0.axis = .horizontal
      $0.alignment = .leading
    }
    
    contentStackView = UIStackView(
      arrangedSubviews: [userNameLabel, travelDurationStackView, uploadedDescriptionLabel]
    ).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.spacing = 3
      $0.axis = .vertical
      $0.distribution = .equalSpacing
      $0.alignment = .leading
    }
    
    uploadedDescriptionLabel.widthAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
    
    super.init(
      frame: frame,
      contentView: contentStackView,
      contentViewSpacing: .init(top: 0, left: 10, bottom: 0, right: 0),
      profileLayoutInfo: .small(.top))
    
    setTapGestureInUserNameLabel()
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}

// MARK: - Helpers
extension PostDetailProfileAreaView {
  func configure(with info: PostDetailProfileAreaInfo) {
    super.configure(with: info.userThumbnailPath)
    userNameLabel.text = info.userName
    travelDurationLabel.text = info.travelDuration
    travelCalendarDateRangeLabel.text = info.travelCalendarDateRange
    uploadedDescriptionLabel.text = info.uploadedDescription
    uploadedDescriptionLabel.textAlignment = .right
  }
}

// MARK: - Private Helpers
private extension PostDetailProfileAreaView {
  func setTapGestureInUserNameLabel() {
    userNameLabel.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
    userNameLabel.addGestureRecognizer(tapGesture)
  }
}
