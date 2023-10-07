//
//  FavoriteDirectorySettingView.swift
//  travelPlan
//
//  Created by 양승현 on 10/7/23.
//

import UIKit

final class FavoriteDirectorySettingView: BottomSheetView {
  enum Constant {
    static let radius: CGFloat = 25

    enum TitleLabel {
      static let font = UIFont(pretendard: .medium, size: 16)!
      static let textColor: UIColor = .yg.gray7
      enum Spacing {
        static let top: CGFloat = 16
        static let leading: CGFloat = 27
        static let trailing = leading
      }
    }
    
    enum SearchBar {
      enum Spacing {
        static let top: CGFloat = 35
        static let leading: CGFloat = 30
        static let trailing = leading
      }
    }
    
    enum OkButton {
      static let height: CGFloat = 39
      enum Spacing {
        static let leading: CGFloat = 20
        static let top: CGFloat = 29.5
        static let trailing = leading
        static let bottom = 10.5
      }
    }
  }
  
  // MARK: - Properties
  private let titleLabel: UILabel = .init(frame: .zero).set {
    typealias Const = Constant.TitleLabel
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = Const.font
    $0.textAlignment = .center
    $0.numberOfLines = 1
    $0.textColor = Const.textColor
  }
  
  private let searchBar = SearchWithCancelView(frame: .zero)
  
  private let okButton = PrimaryColorToneRoundButton(currentState: .normal)
  
  override var intrinsicContentSize: CGSize {
    typealias TitleLabel = Constant.TitleLabel
    typealias SearchBar = Constant.SearchBar
    typealias OkButton = Constant.OkButton
    let superViewIntrinsicHeight = BottomSheetView.Constants.TopView.height
    let titleHeightAndTopSpacing = TitleLabel.font.lineHeight + TitleLabel.Spacing.top
    let searchBarHeightAndTopSpacing = SearchWithCancelView.Constant.height + SearchBar.Spacing.top
    let okButtonHeightAndTopBottomSpacing = OkButton.height + OkButton.Spacing.top + OkButton.Spacing.bottom
    return .init(
      width: 150,
      height: (
        superViewIntrinsicHeight
        + titleHeightAndTopSpacing
        + searchBarHeightAndTopSpacing
        + okButtonHeightAndTopBottomSpacing))
  }
  
  // MARK: - Lifecycle
  init(title: String) {
    super.init(radius: Constant.radius)
    titleLabel.text = title
    translatesAutoresizingMaskIntoConstraints = false
    configureContentView()
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    titleLabel.text = "Setting"
    translatesAutoresizingMaskIntoConstraints = false
    configureContentView()
    backgroundColor = .white
  }
}

// MARK: - Private Helpers
private extension FavoriteDirectorySettingView {
  func configureContentView() {
    setContentView(.init(frame: .zero).set { contentView in
      contentView.translatesAutoresizingMaskIntoConstraints = false
      _=[
        titleLabel,
        searchBar,
        okButton
      ].map {
        contentView.addSubview($0)
      }
      
      _=[
        setTitleLabelConstraints(with: contentView),
        setSearchBarCosntraints(with: contentView),
        setOkButtonConstraints(with: contentView)
      ].map {
        NSLayoutConstraint.activate($0)
      }
    })
  }
  
  // MARK: - Layout
  func setTitleLabelConstraints(with contentView: UIView) -> [NSLayoutConstraint] {
    typealias Const = Constant.TitleLabel
    typealias Spacing = Const.Spacing
    return [
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing),
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.top)
    ]
  }
  
  func setSearchBarCosntraints(with contentView: UIView) -> [NSLayoutConstraint] {
    typealias Const = Constant.SearchBar
    typealias Spacing = Const.Spacing
    return [
      searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.top),
      searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing)]
  }
  
  func setOkButtonConstraints(with contentView: UIView) -> [NSLayoutConstraint] {
    typealias Const = Constant.OkButton
    typealias Spacing = Const.Spacing
    return [
      okButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spacing.leading),
      okButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spacing.trailing),
      okButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Spacing.top),
      okButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.bottom)]
  }
}

// MARK: - Actions
