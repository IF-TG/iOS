//
//  FavoriteListTableViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

final class FavoriteListTableViewCell: UITableViewCell {
  // MARK: - Identifier
  static let id: String = String(describing: PostCell.self)
  
  private lazy var listImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yg.gray1
    $0.layer.cornerRadius = Constant.ImageView.size.width/2.0
    $0.clipsToBounds = true
  }
  
  private let listTitle: UILabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = ""
    $0.textColor = Constant.Title.textColor
    $0.font = .init(
      pretendard: Constant.Title.fontName,
      size: Constant.Title.textSize)
  }
  
  private var titleText: String?
  
  private var innerItemCount: Int?
  
  private var titleAndInnerItemCount: String {
    guard
      let count = innerItemCount,
      let titleText = titleText else {
      return "미정 (00)"
    }
    guard count < 10 else {
      return "\(titleText) (\(count))"
    }
    return "\(titleText) (0\(count))"
  }
  
  // MARK: - Initialization
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension FavoriteListTableViewCell {
  func configure(with data: FavoriteListTableViewCellModel) {
    setListTitleInfo(
      withTitle: data.title,
      withCount: data.innerItemCount)
    setImageView(with: data.image)
  }
}

// MARK: - Private helpers
private extension FavoriteListTableViewCell {
  @MainActor
  func setListTitle(with text: String) {
      self.listTitle.text = text
  }
  
  @MainActor
  func setImageView(with image: UIImage?) {
    self.listImageView.image = image
  }
  
  @MainActor
  func setListTitleInfo(withTitle title: String, withCount count: Int) {
    titleText = title
    innerItemCount = count
    setListTitle(with: titleAndInnerItemCount)
  }
}

// MARK: - LayoutSupport
extension FavoriteListTableViewCell: LayoutSupport {
  func addSubviews() {
    _=[listImageView, listTitle].map { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    _=[listImageViewConstraints, listTitleConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport constriants
private extension FavoriteListTableViewCell {
  var listImageViewConstraints: [NSLayoutConstraint] {
    [listImageView.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor,
      constant: Constant.ImageView.spacing.leading),
     listImageView.topAnchor.constraint(
      equalTo: contentView.topAnchor,
      constant: Constant.ImageView.spacing.top),
     listImageView.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor,
      constant: -Constant.ImageView.spacing.bottom),
     listImageView.heightAnchor.constraint(
      equalToConstant: Constant.ImageView.size.height),
     listImageView.widthAnchor.constraint(
      equalToConstant: Constant.ImageView.size.width)]
  }
  
  var listTitleConstraints: [NSLayoutConstraint] {
    [listTitle.leadingAnchor.constraint(
      equalTo: listImageView.trailingAnchor,
      constant: Constant.Title.spacing.leading),
     listTitle.centerYAnchor.constraint(
      equalTo: contentView.centerYAnchor),
     listTitle.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -Constant.Title.spacing.trailing)]
  }
}
