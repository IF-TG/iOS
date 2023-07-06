//
//  PostViewBottomSheetCategoryCVCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/06.
//

import UIKit

final class PostViewBottomSheetCategoryCVCell: UICollectionViewCell {
  // MARK: - Identnfier
  static let id: String = .init(
    describing: PostViewBottomSheetCategoryCVCell.self)
  
  // MARK: - Constant
  struct Constant {
    enum Title {
      static let size: CGFloat = 16
      static let color: UIColor = .YG.gray5
      static let font: UIFont = .systemFont(
        ofSize: size,
        weight: .semibold)
      static let spacing: UISpacing = .init(leading: 35,top: 15,trailing: 35, bottom: 15)
    }
  }
  
  // MARK: - Properties
  private let title = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "_"
    $0.font = Constant.Title.font
  }
  
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

extension PostViewBottomSheetCategoryCVCell {
  func configure(with title: String) {
    
  }
}
