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
    let imageURL: String?
  }
  
  enum Constant {
    enum QuarterImageView {
      enum Spacing {
        static let leading: CGFloat = 16
      }
      static let size = CGSize(width: 40, height: 40)
    }
    
    enum TitleLabel {
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
  
  private lazy var quarterImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .yg.gray1
    $0.layer.cornerRadius = Constant.QuarterImageView.size.width/2.0
    $0.clipsToBounds = true
  }
  
  private let titleLabel = UILabel().set {
    typealias Const = Constant.TitleLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.textColor = Const.textColor
    $0.font = .init(pretendard: Const.fontName, size: Const.textSize)
  }
  
  // MARK: - Lifecycle
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
  func configure(with data: Model?) {
    let combinedTitle = titleAndInnerItemCount(data?.title, itemCount: data?.innerItemCount)
    self.titleLabel.text = combinedTitle
    guard let imageURL = data?.imageURL else {
      quarterImageView.image = nil
      return
    }
    self.quarterImageView.image = UIImage(named: imageURL)
  }
}

// MARK: - Private helpers
private extension FavoriteTableViewCell {
  private func titleAndInnerItemCount(_ title: String?, itemCount: Int?) -> String {
    return "\(title ?? "미정") (\((itemCount ?? 0).zeroPaddingString))"
  }
}

// MARK: - LayoutSupport
extension FavoriteTableViewCell: LayoutSupport {
  func addSubviews() {
    _=[
      quarterImageView,
      titleLabel
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[
      quarterImageViewConstraints,
      titleLabelConstraints
    ].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport constriants
private extension FavoriteTableViewCell {
  var quarterImageViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.QuarterImageView
    typealias Spacing = Const.Spacing
    return [
      quarterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      quarterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      quarterImageView.heightAnchor.constraint(equalToConstant: Const.size.height),
      quarterImageView.widthAnchor.constraint(equalToConstant: Const.size.width)]
  }
  
  var titleLabelConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.TitleLabel.Spacing
    return [
      titleLabel.leadingAnchor.constraint(equalTo: quarterImageView.trailingAnchor, constant: Spacing.leading),
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing)]
  }
}
