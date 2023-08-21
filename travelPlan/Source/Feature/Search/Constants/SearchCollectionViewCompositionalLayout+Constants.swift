//
//  SearchCollectionViewCompositionalLayout+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import UIKit

extension SearchCollectionViewCompositionalLayout {
  enum Constants {
    // MARK: - First
    enum Festival {
      enum Item {
        static let width: CGFloat = 1
        static let height: CGFloat = 1
      }
      enum Group {
        static let width: CGFloat = 140
        static let height: CGFloat = 150
      }
      enum Section {
        static let interGroupSpacing: CGFloat = 10
        enum Inset {
          static let top: CGFloat = 0
          static let leading: CGFloat = 20
          static let bottom: CGFloat = 0
          static let trailing: CGFloat = 20
        }
      }
    }
    
    // MARK: - Second
    enum Famous {
      enum Item {
        static let width: CGFloat = 1
        static let height: CGFloat = 0.3
      }
      enum Group {
        static let width: CGFloat = 0.87
        static let height: CGFloat = 360
        static let interSpacing: CGFloat = 10
      }
      enum Section {
        static let interSpacing: CGFloat = 20
        enum Inset {
          static let top: CGFloat = 5
          static let leading: CGFloat = 0
          static let bottom: CGFloat = 5
          static var trailing: CGFloat {
            UIScreen.main.bounds.size.width * 0.13
          }
        }
      }
    }
    enum Header {
      static let width: CGFloat = 1
      static let height: CGFloat = 74
    }
  }
}
