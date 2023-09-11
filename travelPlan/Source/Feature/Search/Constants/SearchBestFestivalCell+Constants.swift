//
//  SearchBestFestivalCell+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import Foundation

extension SearchBestFestivalCell {
  enum Constants {
    // MARK: - ThumbnailImageView
    enum ThumbnailImageView {
      static let cornerRadius: CGFloat = 3
    }
    // MARK: - HeartButton
    enum StarButton {
      enum Inset {
        static let top: CGFloat = 8
        static let trailing: CGFloat = 8
      }
      static let size: CGFloat = 24
    }
    // MARK: - FestivalLabel
    enum FestivalLabel {
      static let fontSize: CGFloat = 18
      static let numberOfLines = 1
      enum Inset {
        static let leading: CGFloat = 4
        static let trailing: CGFloat = 4
      }
    }
    // MARK: - PeriodLabel
    enum PeriodLabel {
      static let fontSize: CGFloat = 12
      enum Inset {
        static let trailing: CGFloat = 4
        static let bottom: CGFloat = 6
      }
    }
  }
}
