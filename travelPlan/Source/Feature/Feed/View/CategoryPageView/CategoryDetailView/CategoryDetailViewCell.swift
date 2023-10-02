//
//  CategoryDetailViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

// TODO: - 재사용 관련 문제를 처리하기 어려울 수 있기에
final class CategoryDetailViewCell: UICollectionViewCell {
  // MARK: - Constant
  enum Constant {
    enum Spacing {
      static let top: CGFloat = 0
    }
  }

  static var id: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  // TODO: - 이건 postView 헤더에 추가. 그리고 카테고리 디테일 뷰 셀이 0이 아닐때 이거 추가해야합니다.
//  private lazy var postSortingMenuAreaView = PostSortingMenuAreaView(
//    travelThemeType: )
  
  private var postView = PostCollectionView()
  
  private var viewModel: PostViewModel!
  
  private var postViewAdapter: PostViewAdapter!
  
  private var isViewModelNil: Bool {
    viewModel == nil
  }
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  // TODO: - prepareForReuse 구현하지않고 pageView 도입 에정
}

// MARK: - Helpers
extension CategoryDetailViewCell {
  func configure(with filterInfo: FeedPostSearchFilterInfo
  ) -> UICollectionViewCell {
    setViewModel(with: filterInfo)
    return self
  }
}

// MARK: - Private Helpers
extension CategoryDetailViewCell {
  private func setViewModel(with filterInfo: FeedPostSearchFilterInfo) {
    guard !isViewModelNil else {
      viewModel = PostViewModel(filterInfo: filterInfo)
      postViewAdapter = PostViewAdapter(dataSource: viewModel, collectionView: postView)
      return
    }
  }
}

// MARK: - LayoutSupport
extension CategoryDetailViewCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(postView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      postView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Constant.Spacing.top),
      postView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor),
      postView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor),
      postView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor)])
  }
}
