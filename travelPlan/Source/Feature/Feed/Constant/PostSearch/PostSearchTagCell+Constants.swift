//
//  PostSearchTagCell+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/10.
//

import Foundation

extension PostSearchTagCell {
  enum Constants {
    enum ContentView {
      static let borderWidth: CGFloat = 1
      static let cornerRadius: CGFloat = 13
    }
    enum Recommendation {
      static let backgroundColor = "1BA0EB"
      static let alphaComponent: CGFloat = 0.1
    }
    enum TagLabel {
      static let fontSize: CGFloat = 14
      static let numberOfLines = 1
      enum Inset {
        static let trailing: CGFloat = 13
        static let leading: CGFloat = 13
        static let top: CGFloat = 4
        static let bottom: CGFloat = 4
      }
    }
    enum DeleteButton {
      enum Inset {
        static let trailing: CGFloat = 13
      }
      enum Offset {
        static let leading: CGFloat = 4
      }
      enum Size {
        static let width: CGFloat = 10
        static let height: CGFloat = 10
      }
      static let imageName = "xmark"
    }
  }
}
