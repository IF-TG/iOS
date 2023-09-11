//
//  SearchFamousSpotCell+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import Foundation

extension SearchFamousSpotCell {
  enum Constants {
    // MARK: - ThumbnailImageView
    enum ThumbnailImageView {
      static let imageName = "tempThumbnail1"
      static let cornerRadius: CGFloat = 3
      enum Inset {
        static let top: CGFloat = 5
        static let bottom: CGFloat = 5
      }
    }
    // MARK: - LabelStackView
    enum LabelStackView {
      static let spacing: CGFloat = 0
      enum Offset {
        static let leading: CGFloat = 15
        static let trailing: CGFloat = -20
      }
    }
    // MARK: - HeartButton
    enum HeartButton {
      static let size: CGFloat = 24
      enum Inset {
        static let top: CGFloat = 5
      }
    }
    // MARK: - PlaceLabel
    enum PlaceLabel {
      static let fontSize: CGFloat = 16
      static let numberOfLines = 1
    }
    // MARK: - CategoryLabel
    enum CategoryLabel {
      static let fontSize: CGFloat = 14
      static let numberOfLines = 1
    }
    // MARK: - AreaLabel
    enum AreaLabel {
      static let size: CGFloat = 14
      static let numberOfLines = 1
    }
  }
}
