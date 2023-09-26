//
//  PostViewBottomSheetCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/06.
//

import UIKit

final class PostViewBottomSheetCell: UITableViewCell {
  // MARK: - Identnfier
  static let id: String = .init(
    describing: PostViewBottomSheetCell.self)
  
  // MARK: - Constant
  struct Constant {
    enum Title {
      static let size: CGFloat = 16
      static let color: UIColor = .YG.gray5
      static let font: UIFont = .systemFont(
        ofSize: size,
        weight: .semibold)
      static let spacing: UISpacing = .init(
        leading: 35, top: 15, trailing: 35, bottom: 15)
    }
  }
  
  // MARK: - Properties
  private let title = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "_"
    $0.font = Constant.Title.font
    $0.textColor = Constant.Title.color
  }
  
  // MARK: - Lifecycle
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Helper
extension PostViewBottomSheetCell {
  func configure(with title: String) {
    self.title.text = title
  }
}

// MARK: - Private helper
extension PostViewBottomSheetCell: LayoutSupport {
  func addSubviews() {
    addSubview(title)
  }
  
  func setConstraints() {
    _=[titleConstraints]
      .map {
        NSLayoutConstraint.activate($0)
      }
  }
}

// MARK: - LayoutSupport helper
private extension PostViewBottomSheetCell {
  var titleConstraints: [NSLayoutConstraint] {
    let spacing = Constant.Title.spacing
    return [
      title.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: spacing.leading),
      title.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: spacing.top),
      title.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -spacing.trailing),
      title.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -spacing.bottom)]
  }
}
