//
//  FavoriteListTotalStateView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

final class FavoriteListHeaderView: UITableViewHeaderFooterView {
  // MARK: - Idenrifier
  static let id: String = String(
    describing: FavoriteListHeaderView.self)
  
  // MARK: - Properties
  private let imageViews = FavoriteListHeaderImageViews()
  
  private let title: UILabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "전체 (00)"
    $0.numberOfLines = 1
    $0.textColor = Constant.Title.textColor
    $0.font = .init(
      pretendard: Constant.Title.fontName,
      size: Constant.Title.textSize)
  }
  
  private var totalCount: Int?
  
  private let line = OneUnitHeightLine(color: .yg.gray0)
  
  // MARK: - Initialization
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
// MARK: - Helpers
extension FavoriteListHeaderView {
  func configure(with data: FavoriteListHeaderModel) {
    setTitle(with: data.categoryCount)
    setImageViews(with: data.images)
  }
  
  func updateTotalCount(with count: Int) {
    totalCount = count
  }
}

// MARK: - Private helpers
private extension FavoriteListHeaderView {
  func configureUI() {
    setupUI()
    line.setConstraint(fromSuperView: contentView)
    line.setHeight(FavoriteListTableView.innerGrayLineHeight)
  }
  
  @MainActor
  func setTitle(with count: Int) {
    totalCount = count
    guard count < 10 else {
      title.text = "전체 (\(count))"
      return
    }
    title.text = "전체 (0\(count))"
  }
  
  @MainActor
  func setImageViews(with images: [UIImage?]) {
    imageViews.configure(with: images)
  }
}

// MARK: - LayoutSupport
extension FavoriteListHeaderView: LayoutSupport {
  func addSubviews() {
    _=[imageViews, title].map { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    // imageViewsConstraint
    NSLayoutConstraint.activate([
      imageViews.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Constant.ImageViews.spacing.leading),
      imageViews.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Constant.ImageViews.spacing.top),
      imageViews.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Constant.ImageViews.spacing.bottom),
      imageViews.widthAnchor.constraint(
        equalToConstant: Constant.ImageViews.size.width),
      imageViews.heightAnchor.constraint(
        equalToConstant: Constant.ImageViews.size.height)])
    
    // titleConstraint
    NSLayoutConstraint.activate([
      title.leadingAnchor.constraint(
        equalTo: imageViews.trailingAnchor,
        constant: Constant.Title.spacing.leading),
      title.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.Title.spacing.trailing),
      title.centerYAnchor.constraint(equalTo: centerYAnchor)])
  }
}
