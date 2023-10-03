//
//  FavoriteHeaderView.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/20.
//

import UIKit

final class FavoriteHeaderView: UITableViewHeaderFooterView {
  struct Model {
    let categoryCount: Int
    let images: [UIImage?]
  }
  
  enum Constant {
    enum ImageViews {
      enum Spacing {
        static let leading: CGFloat = 20
        static let top: CGFloat = 15
        static let bottom: CGFloat = 16
      }
      static let size = CGSize(width: 40, height: 40)
    }
    
    enum Title {
      enum Spacing {
        static let leading: CGFloat = 15
        static let trailing: CGFloat = 43
      }
      static let textColor: UIColor = .yg.gray6
      static let fontName: UIFont.Pretendard = .medium
      static let textSize: CGFloat = 15.0
    }
  }

  // MARK: - Idenrifier
  static let id: String = String(
    describing: FavoriteHeaderView.self)
  
  // MARK: - Properties
  private let imageViews = FavoriteHeaderImageViews()
  
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
extension FavoriteHeaderView {
  func configure(with data: Model) {
    setTitle(with: data.categoryCount)
    setImageViews(with: data.images)
  }
  
  func updateTotalCount(with count: Int) {
    totalCount = count
  }
}

// MARK: - Private helpers
private extension FavoriteHeaderView {
  func configureUI() {
    setupUI()
    line.setConstraint(fromSuperView: contentView)
    line.setHeight(FavoriteTableView.innerGrayLineHeight)
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
extension FavoriteHeaderView: LayoutSupport {
  func addSubviews() {
    _=[
      imageViews,
      title
    ].map {
      contentView.addSubview($0)
    }
  }
  
  func setConstraints() {
   _=[
    imageViewConstraints,
    titleConstraints
   ].map {
     NSLayoutConstraint.activate($0)
   }
  }
}

private extension FavoriteHeaderView {
  var imageViewConstraints: [NSLayoutConstraint] {
    typealias Const = Constant.ImageViews
    typealias Spacing = Const.Spacing
    return [
      imageViews.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Spacing.leading),
      imageViews.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Spacing.top),
      imageViews.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Spacing.bottom),
      imageViews.widthAnchor.constraint(
        equalToConstant: Const.size.width),
      imageViews.heightAnchor.constraint(
        equalToConstant: Const.size.height)]
  }
  
  var titleConstraints: [NSLayoutConstraint] {
    typealias Spacing = Constant.Title.Spacing
    return [
      title.leadingAnchor.constraint(
        equalTo: imageViews.trailingAnchor,
        constant: Spacing.leading),
      title.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Spacing.trailing),
      title.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
}
