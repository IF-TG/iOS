//
//  FavoriteTableViewCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
  struct Model {
    let title: String
    let innerItemCount: Int
    let image: UIImage?
  }
  
  enum Constant {
    enum ImageView {
      enum Spacing {
        static let leading: CGFloat = 16
      }
      static let size = CGSize(width: 40, height: 40)
    }
    
    enum Title {
      enum Spacing {
        static let leading: CGFloat = 15
        static let trailing: CGFloat = 44
      }
      static let textColor: UIColor = .yg.gray6
      static let fontName: UIFont.Pretendard = .medium
      static let textSize: CGFloat = 15.0
    }
  }

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
    $0.numberOfLines = 1
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
    selectionStyle = .none
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension FavoriteTableViewCell {
  func configure(with data: Model) {
    setListTitleInfo(
      withTitle: data.title,
      withCount: data.innerItemCount)
    setImageView(with: data.image)
  }
}

// MARK: - Private helpers
private extension FavoriteTableViewCell {
  func setListTitle(with text: String) {
      self.listTitle.text = text
  }
  
  func setImageView(with image: UIImage?) {
    self.listImageView.image = image
  }
  
  func setListTitleInfo(withTitle title: String, withCount count: Int) {
    titleText = title
    innerItemCount = count
    setListTitle(with: titleAndInnerItemCount)
  }
}

// MARK: - LayoutSupport
extension FavoriteTableViewCell: LayoutSupport {
  func addSubviews() {
    _=[
      listImageView,
      listTitle
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      listImageViewConstraints,
      listTitleConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport constriants
private extension FavoriteTableViewCell {
  var listImageViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.ImageView
    typealias Spacing = Const.Spacing
    return [
      listImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      listImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      listImageView.heightAnchor.constraint(equalToConstant: Const.size.height),
      listImageView.widthAnchor.constraint(equalToConstant: Const.size.width)]
  }
  
  var listTitleConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.Title.Spacing
    return [
      listTitle.leadingAnchor.constraint(equalTo: listImageView.trailingAnchor, constant: Spacing.leading),
      listTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      listTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing)]
  }
}
