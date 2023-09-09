//
//  DefaultSearchLayout+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import UIKit

extension DefaultSearchLayout {
  enum Constants {
    // MARK: - First
    enum Festival {
      enum Item {
        static let fractionalWidth: CGFloat = 1
        static let fractionalHeight: CGFloat = 1
      }
      enum Group {
        static let width: CGFloat = 140
        static let height: CGFloat = 150
      }
      enum Section {
        static let interGroupSpacing: CGFloat = 10
        enum Inset {
          static let top: CGFloat = 0
          static let leading: CGFloat = 16
          static let bottom: CGFloat = 0
          static let trailing: CGFloat = 16
        }
      }
    }
    
    // MARK: - Second
    enum Famous {
      enum Item {
        static let fractionalWidth: CGFloat = 1
        static let fractionalHeight: CGFloat = 0.3
      }
      enum Group {
        static var fractionalWidth: CGFloat {
          let fractionalWidth = 314 / UIScreen.main.bounds.size.width
          return CGFloat((String(format: "%.3f", fractionalWidth) as NSString).floatValue)
        }
        static let height: CGFloat = 360
        static let interSpacing: CGFloat = 10
      }
      enum Section {
        enum Inset {
          static let top: CGFloat = 5
          static let leading: CGFloat = 16
          static let bottom: CGFloat = 5
          static var trailing: CGFloat = 16
        }
        static let interGroupSpacing: CGFloat = 16
      }
    }
    
    enum Header {
      static let fractionalWidth: CGFloat = 1.0
      static let estimatedHeight: CGFloat = 74
    }
  }
}
