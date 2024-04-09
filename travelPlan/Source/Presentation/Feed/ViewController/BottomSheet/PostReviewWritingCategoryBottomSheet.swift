//
//  PostReviewWritingCategoryBottomSheet.swift
//  travelPlan
//
//  Created by 양승현 on 4/9/24.
//

import UIKit


final class PostReviewWritingCategoryBottomSheet: BaseBottomSheetViewController {
  @frozen enum SectionType: Int, CaseIterable {
    case description = 0
    case mainTheme = 1
    case subTheme = 2
    
    static var numberOfSections: Int {
      SectionType.allCases.count
    }
    
    init?(rawValue: Int) {
      switch rawValue {
      case 0:
        self = .description
      case 1:
        self = .mainTheme
      case 2:
        self = .subTheme
      default :
        return nil
      }
    }
  }
  
  // MARK: - Properties
  private let tableView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().set {
      $0.minimumLineSpacing = 8
      $0.minimumInteritemSpacing = 8
      $0.sectionInset = .init(top: 0, left: 7, bottom: 0, right: 7)
    })
  
  // TODO: - 화면 아래 초기화, 확인 구현해야 합니다.
  private let selectCompletionView = UIView()
  
  // MARK: - Lifecycle
  override init(contentView: UIView, mode: BaseBottomSheetViewController.ContentMode, radius: CGFloat) {
    super.init(contentView: tableView, mode: .full, radius: 15)
    // TODO: - 뷰추가하자
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Private Helpers
  private func setNextView() { }
}
