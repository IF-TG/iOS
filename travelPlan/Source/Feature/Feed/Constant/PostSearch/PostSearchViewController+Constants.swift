//
//  PostSearchViewController+Constants.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/08/09.
//

import Foundation

extension PostSearchViewController {
  enum Constants {
    enum SearchSection {
      static let recommendation = 0
      static let recent = 0
    }
    
    enum SearchBarButtonItem {
      static let imageName = "search"
    }
    
    enum SearchTextField {
      static let placeholder = "여행자들의 여행 리뷰를 검색해보세요."
      static let width: CGFloat = 260
      static let fontSize: CGFloat = 16
    }
    
    enum BackButtonItem {
      static let imageName = "back"
    }
    
    enum CollectionViewLayout {
      static let lineSpacing: CGFloat = 16
      static let itemSpacing: CGFloat = 8
      enum Inset {
        static let top: CGFloat = 10
        static let left: CGFloat = 20
        static let bottom: CGFloat = 10
        static let right: CGFloat = 20
      }
    }
    
    enum Alert {
      static let message = "최근 검색 내역을\n모두 삭제하시겠습니까?"
    }
  }
}
