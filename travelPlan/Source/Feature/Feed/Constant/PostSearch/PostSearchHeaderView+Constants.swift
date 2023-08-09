//
//  PostSearchHeaderView+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import Foundation

extension PostSearchHeaderView {
  enum Constants {
    enum TitleLabel {
      static let fontSize: CGFloat = 17
      enum Inset {
        static let leading: CGFloat = 20
      }
    }
    enum DeleteAllButton {
      static let title = "전체 삭제"
      static let titleFontSize: CGFloat = 12
      enum Inset {
        static let trailing: CGFloat = 30
      }
    }
  }
}
