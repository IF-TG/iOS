//
//  PostSearchViewModel+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/10.
//

import Foundation

extension PostSearchViewModel {
  enum Constants {
    enum DynamicCellSize {
      static let fontSize: CGFloat = 14
      static let fontName = "Pretendard-Medium"
      
      static let insetWidthPadding: CGFloat = PostSearchTagCell.Constants.TagLabel.Inset.trailing +
      PostSearchTagCell.Constants.TagLabel.Inset.leading
      
      static let insetHeightPadding: CGFloat = PostSearchTagCell.Constants.TagLabel.Inset.top +
      PostSearchTagCell.Constants.TagLabel.Inset.bottom
      
      static let buttonWidth: CGFloat = PostSearchTagCell.Constants.DeleteButton.Size.width
      
      static let componentsPadding: CGFloat = PostSearchTagCell.Constants.DeleteButton.Offset.leading
    }
  }
}
