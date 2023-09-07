//
//  SearchViewController+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import Foundation

extension SearchViewController {
  enum Constants {
    // MARK: - SearchView
    enum SearchView {
      enum Spacing {
        static let top: CGFloat = 20
        static let leading: CGFloat = 16
        static let trailing: CGFloat = 16
      }
      static let height: CGFloat = 50
    }
    // MARK: - CollectionView
    enum CollectionView {
      enum Spacing {
        enum Offset {
          static let top: CGFloat = 20
        }
      }
    }
  }
}
