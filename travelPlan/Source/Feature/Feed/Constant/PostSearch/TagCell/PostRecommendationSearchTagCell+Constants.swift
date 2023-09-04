//
//  PostRecommendationSearchTagCell+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/10.
//

import Foundation

extension PostRecommendationSearchTagCell {
  enum Constants {
    enum ContentView {
      static let borderWidth: CGFloat = 1
      static let cornerRadius: CGFloat = 13
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
  }
}
