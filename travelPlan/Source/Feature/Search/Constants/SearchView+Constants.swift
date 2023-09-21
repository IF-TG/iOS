//
//  SearchView+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import Foundation

extension SearchView {
  enum Constants {
    static let borderWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 25
    // MARK: - SearchButton
    enum SearchButton {
      static let imageName = "search"
      enum Offset {
        static let leading: CGFloat = 10
      }
      enum Inset {
        static let trailing: CGFloat = 20
        static let topBottom: CGFloat = 11
      }
    }
    // MARK: - SearchTextField
    enum SearchTextField {
      static let placeholder = "여행지 및 축제를 검색해보세요."
      static let fontSize: CGFloat = 14
      enum Inset {
        static let leading: CGFloat = 20
      }
    }
  }
}
