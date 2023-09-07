//
//  PostSearchCollectionViewCompositionalLayout+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/06.
//

import Foundation

extension PostSearchCollectionViewCompositionalLayout {
  enum Constants {
    enum Recommendation {
      enum Item {
        static let estimatedWidth: CGFloat = 50
        static let absoluteHeight: CGFloat = 30
      }
      enum Group {
        static let estimatedWidth: CGFloat = 50
        static let absoluteHeight: CGFloat = 30
      }
      enum Section {
        static let interGroupSpacing: CGFloat = 8
        enum ContentInset {
          static let top: CGFloat = 8
          static let leading: CGFloat = 20
          static let bottom: CGFloat = 8
          static let trailing: CGFloat = 20
        }
      }
    }
    
    enum Recent {
      enum Item {
        static let estimatedWidth: CGFloat = 50
        static let absoluteHeight: CGFloat = 30
      }
      enum Group {
        static let fractionalWidth: CGFloat = 1.0
        static let absoluteHeight: CGFloat = 30
        static let interItemSpacing: CGFloat = 8
      }
      enum Section {
        static let interGroupSpacing: CGFloat = 16
        enum ContentInsets {
          static let top: CGFloat = 8
          static let leading: CGFloat = 20
          static let bottom: CGFloat = 8
          static let trailing: CGFloat = 20
        }
      }
    }
    
    enum Header {
      static let fractionalWidth: CGFloat = 1.0
      static let absoluteHeight: CGFloat = 60
    }
    enum Footer {
      static let fractionalWidth: CGFloat = 1.0
      static let absoluteHeight: CGFloat = 21
    }
  }
}
