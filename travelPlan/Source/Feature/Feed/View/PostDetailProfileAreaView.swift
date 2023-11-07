//
//  PostDetailProfileAreaView.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import UIKit

final class PostDetailProfileAreaView: BaseProfileAreaView {
  enum Constant {
    enum UserNameLabel {
      enum Spacing {
        static let top: CGFloat = 3
        static let trailing: CGFloat = 10
      }
    }
    enum TravelDurationStackView {
      static let height: CGFloat = 18
      static let spacing: CGFloat = 10
      enum Spacing {
        static let top: CGFloat = 6
      }
    }
    enum UploadedDescriptionLabel {
      enum Spacing {
        static let top: CGFloat = 3
      }
    }
  }
  
  // MARK: - Properties
  private let userNameLabel = BaseLabel(fontType: .medium_500(fontSize: 15)).set {
    $0.backgroundColor = .yg.gray7
  }
  
  private let travelDurationLabel = BaseLabel(fontType: .medium_500(fontSize: 12), lineHeight: 14.32).set {
    $0.backgroundColor = .yg.gray5
  }
  
  private let travelCalendarDateRangeLabel = BaseLabel(fontType: .medium_500(fontSize: 12), lineHeight: 14.32).set {
    $0.backgroundColor = .yg.gray5
  }
  
  private let durationDivider = UILabel().set {
    $0.backgroundColor = .yg.gray5
    $0.heightAnchor.constraint(equalToConstant: 13).isActive = true
    $0.widthAnchor.constraint(equalToConstant: 1).isActive = true
  }
  
  private let uploadedDescriptionLabel = BaseLabel(fontType: .regular_400(fontSize: 12), lineHeight: 14.32).set {
    $0.backgroundColor = .yg.gray5
  }
  
  private lazy var travelDurationStackView: UIStackView = UIStackView(
    arrangedSubviews: [travelDurationLabel, durationDivider, travelCalendarDateRangeLabel]
  ).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.spacing = Constant.TravelDurationStackView.spacing
    $0.axis = .horizontal
    $0.alignment = .leading
  }
}
