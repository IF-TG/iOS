//
//  TravelThemeBottomSheetCell.swift
//  travelPlan
//
//  Created by 양승현 on 2023/09/18.
//

import UIKit

final class TravelThemeBottomSheetCell: UITableViewCell {
  enum Constants {
    enum Title {
      static let textSize: CGFloat = 16
      static let textColor: UIColor = .yg.gray5
      enum Inset {
        static let leading: CGFloat = 35
        static let trailing = leading
      }
    }
  }
  
  static let id: String = .init(describing: TravelThemeBottomSheetCell.self)
  
  // MARK: - Properties
  private let title: UILabel = UILabel(frame: .zero).set {
    typealias Const = Constants.Title
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.boldSystemFont(ofSize: Const.textSize)
    $0.textColor = Const.textColor
    $0.numberOfLines = 1
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    configure(with: nil)
  }
}

// MARK: - Helpers
extension TravelThemeBottomSheetCell {
  func configure(with text: String?) {
    title.text = text
  }
}


// MARK: - LayoutSupport
extension TravelThemeBottomSheetCell: LayoutSupport {
  func addSubviews() {
    contentView.addSubview(title)
  }
  
  func setConstraints() {
    typealias Inset = Constants.Title.Inset
    NSLayoutConstraint.activate([
      title.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: Inset.leading),
      title.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Inset.trailing),
      title.centerYAnchor.constraint(
        equalTo: contentView.centerYAnchor)])
  }
}
