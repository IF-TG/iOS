//
//  SearchHeaderView+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import Foundation

extension SearchHeaderView {
  enum Constants {
    // MARK: - HeaderLabel
    enum HeaderLabel {
      static let fontSize: CGFloat = 25
      static let numberOfLines = 1
      enum Inset {
        static let top: CGFloat = 31
        static let bottom: CGFloat = 21
      }
      enum Offset {
        static let trailing: CGFloat = -15
      }
    }
    // MARK: - LookingMoreButton
    enum LookingMoreButton {
      static let title = "더보기"
      static let titleFontSize: CGFloat = 12
      static let imageName = "plus"
      static let cornerRadius: CGFloat = 14
      static let borderWidth: CGFloat = 1
      enum Inset {
        static let trailing: CGFloat = 4
      }
      static let width: CGFloat = 64
      static let height: CGFloat = 28
    }
  }
}
