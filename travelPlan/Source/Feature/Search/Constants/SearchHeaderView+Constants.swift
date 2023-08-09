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
        static let leading: CGFloat = 20
        static let top: CGFloat = 30
        static let bottom: CGFloat = 20
      }
      enum Offset {
        static let trailing: CGFloat = -20
      }
    }
    // MARK: - LookingMoreButton
    enum LookingMoreButton {
      static let title = "더보기"
      static let titleFontSize: CGFloat = 12
      static let imageName = "plus"
      static let cornerRadius: CGFloat = 12
      static let borderWidth: CGFloat = 1
      enum Inset {
        static let trailing: CGFloat = 20
      }
      static let width: CGFloat = 64
      static let height: CGFloat = 24
    }
  }
}
