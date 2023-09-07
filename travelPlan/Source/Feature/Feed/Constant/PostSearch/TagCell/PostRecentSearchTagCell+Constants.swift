//
//  PostRecentSearchTagCell+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/30.
//

import Foundation

extension PostRecentSearchTagCell {
  enum Constants {
    enum ContentView {
      static let borderWidth: CGFloat = 1
      static let cornerRadius: CGFloat = 15
    }
    
    enum TagLabel {
      enum Inset {
        static let leading: CGFloat = 10
        static let topBottom: CGFloat = 4
      }
      enum Offset {
        static let trailing: CGFloat = -4
      }
    }
    
    enum TagDeleteButton {
      enum Inset {
        static let trailing: CGFloat = 10
      }
      static let size: CGFloat = 18
      static let imageName = "cancel"
    }
    
    static let targetSizeHeight: CGFloat = PostSearchCollectionViewCompositionalLayout
      .Constants.Recent.Item.absoluteHeight
    static let contentInsets: CGFloat = PostSearchCollectionViewCompositionalLayout
      .Constants.Recent.Section.ContentInsets.leading + PostSearchCollectionViewCompositionalLayout
      .Constants.Recent.Section.ContentInsets.trailing
  }
}
