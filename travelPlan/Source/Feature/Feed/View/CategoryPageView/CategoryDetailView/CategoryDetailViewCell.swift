//
//  CategoryDetailViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/09.
//

import UIKit

final class CategoryDetailViewCell: UICollectionViewCell {
  // MARK: - Constant
  static var id: String {
    return String(describing: self)
  }
  
  // MARK: - Properties
  private var travelThemeType: TravelThemeType = .all
  
  private var travelTrendType: TravelTrend = .newest
  
  private lazy var postSortingMenuAreaView = PostSortingMenuAreaView(
    travelThemeType: travelThemeType)
  
  private var postView: PostCollectionView!
  
  private var postViewAdapter: PostViewAdapter!
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public helpers
extension CategoryDetailViewCell {
  func configure(
    data: [PostModel],
    travelThemeType: TravelThemeType,
    travelTrendType: TravelTrend
  ) -> UICollectionViewCell {
    self.travelThemeType = travelThemeType
    self.travelTrendType = travelTrendType
    setPostView(with: data)
    return self
  }
}

// MARK: - Helpers
extension CategoryDetailViewCell {
  private func setPostView(with data: [PostModel]) {
    if postView == nil {
      let postViewModel = PostViewModel(data: data)
      postView = PostCollectionView(viewModel: postViewModel)
      postViewAdapter = PostViewAdapter(
        dataSource: postViewModel,
        collectionView: postView)
      setupUI()
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
